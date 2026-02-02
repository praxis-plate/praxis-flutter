import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/usecases/tasks/request_task_hint_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_hint_state.dart';

class TaskHintCubit extends Cubit<TaskHintState> {
  final RequestTaskHintUseCase _requestTaskHintUseCase;
  final String _userId;

  TaskHintCubit(this._requestTaskHintUseCase, this._userId)
    : super(const TaskHintInitial());

  Future<void> requestHint(int taskId) async {
    emit(const TaskHintLoading());

    final result = await _requestTaskHintUseCase(
      taskId: taskId,
      userId: _userId,
    );

    result.when(
      success: (hint) => emit(TaskHintLoaded(hint)),
      failure: (failure) => emit(TaskHintError(failure.message)),
    );
  }

  void reset() {
    emit(const TaskHintInitial());
  }
}
