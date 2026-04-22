import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/task/task_model.dart';
import 'package:praxis/domain/usecases/tasks/complete_lesson_session_usecase.dart';
import 'package:praxis/domain/usecases/tasks/get_lesson_tasks_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lesson_task_session_event.dart';
part 'lesson_task_session_state.dart';

class LessonTaskSessionBloc
    extends Bloc<LessonTaskSessionEvent, LessonTaskSessionState> {
  final GetLessonTasksUseCase _getLessonTasksUseCase;
  final CompleteLessonSessionUseCase _completeLessonSessionUseCase;

  LessonTaskSessionBloc(
    this._getLessonTasksUseCase,
    this._completeLessonSessionUseCase,
  ) : super(const SessionInitialState()) {
    on<StartSessionEvent>(_onStartSessionEvent);
    on<CompleteCurrentTaskEvent>(_onCompleteCurrentTaskEvent);
    on<ExitSessionEvent>(_onExitSessionEvent);
  }

  Future<void> _onStartSessionEvent(
    StartSessionEvent event,
    Emitter<LessonTaskSessionState> emit,
  ) async {
    emit(const SessionLoadingState());
    try {
      final result = await _getLessonTasksUseCase(event.lessonId);

      result.when(
        success: (tasks) {
          if (tasks.isEmpty) {
            emit(
              const SessionErrorState(type: LessonTaskSessionErrorType.noTasks),
            );
            return;
          }

          emit(
            SessionActiveState(
              lessonId: event.lessonId,
              userId: event.userId,
              tasks: tasks,
              currentTaskIndex: 0,
              completedTasksCount: 0,
              correctTasksCount: 0,
              totalXpEarned: 0,
              sessionStartTime: DateTime.now(),
            ),
          );
        },
        failure: (failure) => emit(
          SessionErrorState(
            type: LessonTaskSessionErrorType.generic,
            failure: failure,
          ),
        ),
      );
    } catch (e) {
      emit(
        SessionErrorState(
          type: LessonTaskSessionErrorType.generic,
          failure: AppFailure.fromException(e),
        ),
      );
    }
  }

  Future<void> _onCompleteCurrentTaskEvent(
    CompleteCurrentTaskEvent event,
    Emitter<LessonTaskSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SessionActiveState) return;

    final newCompletedCount = currentState.completedTasksCount + 1;
    final newCorrectCount = event.isCorrect
        ? currentState.correctTasksCount + 1
        : currentState.correctTasksCount;
    final newTotalXp = currentState.totalXpEarned + event.xpEarned;

    if (currentState.isLastTask) {
      final timeSpent = DateTime.now()
          .difference(currentState.sessionStartTime)
          .inSeconds;
      final accuracy = newCorrectCount / newCompletedCount;

      const bonusXp = 100;
      final totalXpWithBonus = newTotalXp + bonusXp;

      try {
        await _completeLessonSessionUseCase(
          userId: currentState.userId,
          lessonId: currentState.lessonId,
          totalXpEarned: newTotalXp,
          bonusXp: bonusXp,
        );

        emit(
          SessionCompletedState(
            lessonId: currentState.lessonId,
            totalXpEarned: totalXpWithBonus,
            accuracyPercentage: accuracy * 100,
            timeSpentSeconds: timeSpent,
            totalTasks: currentState.tasks.length,
            correctTasks: newCorrectCount,
          ),
        );
      } catch (e) {
        emit(
          SessionErrorState(
            type: LessonTaskSessionErrorType.generic,
            failure: AppFailure.fromException(e),
          ),
        );
      }
    } else {
      emit(
        currentState.copyWith(
          currentTaskIndex: currentState.currentTaskIndex + 1,
          completedTasksCount: newCompletedCount,
          correctTasksCount: newCorrectCount,
          totalXpEarned: newTotalXp,
        ),
      );
    }
  }

  Future<void> _onExitSessionEvent(
    ExitSessionEvent event,
    Emitter<LessonTaskSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is SessionActiveState && event.saveProgress) {
      return;
    }
    emit(const SessionInitialState());
  }
}
