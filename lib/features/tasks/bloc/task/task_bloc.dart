import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/task/task_model.dart';
import 'package:codium/domain/models/task/task_progress_model.dart';
import 'package:codium/domain/models/task/task_result_model.dart';
import 'package:codium/domain/usecases/tasks/get_task_by_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/request_task_hint_usecase.dart';
import 'package:codium/domain/usecases/tasks/submit_task_answer_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTaskByIdUseCase _getTaskByIdUseCase;
  final SubmitTaskAnswerUseCase _submitTaskAnswerUseCase;
  final RequestTaskHintUseCase _requestTaskHintUseCase;

  int _hintsUsed = 0;
  String _currentUserId = '1';

  TaskBloc(
    this._getTaskByIdUseCase,
    this._submitTaskAnswerUseCase,
    this._requestTaskHintUseCase, {
    String? userId,
  }) : super(const TaskInitialState()) {
    _currentUserId = userId ?? '1';
    on<LoadTaskEvent>(_onLoadTaskEvent);
    on<SubmitAnswerEvent>(_onSubmitAnswerEvent);
    on<RequestHintEvent>(_onRequestHintEvent);
    on<RetryTaskEvent>(_onRetryTaskEvent);
  }

  Future<void> _onLoadTaskEvent(
    LoadTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoadingState());
    try {
      final result = await _getTaskByIdUseCase(event.taskId);

      result.when(
        success: (task) => emit(TaskLoadedState(task: task)),
        failure: (failure) => emit(TaskErrorState(failure)),
      );
    } catch (e) {
      emit(TaskErrorState(AppFailure.fromException(e)));
    }
  }

  Future<void> _onSubmitAnswerEvent(
    SubmitAnswerEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TaskLoadedState) return;

    emit(TaskAnswerValidatingState(currentState.task));
    try {
      final result = await _submitTaskAnswerUseCase(
        taskId: currentState.task.id,
        answer: event.answer,
        userId: _currentUserId,
        hintsUsed: _hintsUsed,
      );

      result.when(
        success: (taskResult) {
          if (taskResult.isCorrect) {
            emit(
              TaskAnswerCorrectState(
                task: currentState.task,
                result: taskResult,
              ),
            );
          } else {
            emit(
              TaskAnswerIncorrectState(
                task: currentState.task,
                result: taskResult,
              ),
            );
          }
        },
        failure: (failure) => emit(TaskErrorState(failure)),
      );
    } catch (e) {
      emit(TaskErrorState(AppFailure.fromException(e)));
    }
  }

  Future<void> _onRequestHintEvent(
    RequestHintEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TaskLoadedState) return;

    emit(TaskHintLoadingState(currentState.task));
    try {
      final result = await _requestTaskHintUseCase(
        taskId: currentState.task.id,
        userId: _currentUserId,
      );

      result.when(
        success: (hint) {
          _hintsUsed++;
          emit(
            TaskHintLoadedState(
              task: currentState.task,
              hint: hint,
              hintsUsed: _hintsUsed,
            ),
          );
        },
        failure: (failure) =>
            emit(TaskHintErrorState(task: currentState.task, failure: failure)),
      );
    } catch (e) {
      emit(
        TaskHintErrorState(
          task: currentState.task,
          failure: AppFailure.fromException(e),
        ),
      );
    }
  }

  Future<void> _onRetryTaskEvent(
    RetryTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskAnswerIncorrectState) {
      emit(TaskLoadedState(task: currentState.task));
    } else if (currentState is TaskHintLoadedState) {
      emit(TaskLoadedState(task: currentState.task));
    }
  }
}
