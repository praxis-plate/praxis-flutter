import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/achievement/achievement_data_model.dart';
import 'package:praxis/domain/models/course/course_assessment_model.dart';
import 'package:praxis/domain/models/task/task_model.dart';
import 'package:praxis/domain/usecases/course/get_course_assessment_usecase.dart';
import 'package:praxis/domain/usecases/lesson/get_lesson_by_id_usecase.dart';
import 'package:praxis/domain/usecases/tasks/complete_lesson_session_usecase.dart';
import 'package:praxis/domain/usecases/tasks/get_lesson_tasks_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lesson_task_session_event.dart';
part 'lesson_task_session_state.dart';

class LessonTaskSessionBloc
    extends Bloc<LessonTaskSessionEvent, LessonTaskSessionState> {
  final GetLessonByIdUseCase _getLessonByIdUseCase;
  final GetLessonTasksUseCase _getLessonTasksUseCase;
  final CompleteLessonSessionUseCase _completeLessonSessionUseCase;
  final GetCourseAssessmentUseCase _getCourseAssessmentUseCase;

  LessonTaskSessionBloc(
    this._getLessonByIdUseCase,
    this._getLessonTasksUseCase,
    this._completeLessonSessionUseCase,
    this._getCourseAssessmentUseCase,
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
      final lessonResult = await _getLessonByIdUseCase(event.lessonId);
      final lessonTitle = lessonResult.dataOrNull?.title;
      final result = await _getLessonTasksUseCase(event.lessonId);

      result.when(
        success: (tasks) {
          if (tasks.isEmpty) {
            emit(
              SessionErrorState(
                type: LessonTaskSessionErrorType.noTasks,
                lessonTitle: lessonTitle,
              ),
            );
            return;
          }

          emit(
            SessionActiveState(
              lessonId: event.lessonId,
              userId: event.userId,
              courseId: event.courseId,
              lessonTitle: lessonTitle ?? '',
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
            lessonTitle: lessonTitle,
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
        emit(
          SessionCompletedState(
            lessonId: currentState.lessonId,
            lessonTitle: currentState.lessonTitle,
            totalXpEarned: totalXpWithBonus,
            accuracyPercentage: accuracy * 100,
            timeSpentSeconds: timeSpent,
            totalTasks: currentState.tasks.length,
            correctTasks: newCorrectCount,
            isPersisting: true,
          ),
        );

        final completionResult = await _completeLessonSessionUseCase(
          userId: currentState.userId,
          lessonId: currentState.lessonId,
          timeSpentSeconds: timeSpent,
          totalXpEarned: newTotalXp,
          bonusXp: bonusXp,
          correctTasks: newCorrectCount,
          totalTasks: currentState.tasks.length,
        );
        if (completionResult.isFailure) {
          emit(
            SessionErrorState(
              type: LessonTaskSessionErrorType.generic,
              failure: completionResult.failureOrNull,
              lessonTitle: currentState.lessonTitle,
            ),
          );
          return;
        }

        CourseAssessmentModel? courseAssessment;
        final courseId = currentState.courseId;
        if (courseId != null) {
          final assessmentResult = await _getCourseAssessmentUseCase.call(
            userId: currentState.userId,
            courseId: courseId,
          );
          if (assessmentResult.isFailure) {
            emit(
              SessionErrorState(
                type: LessonTaskSessionErrorType.generic,
                failure: assessmentResult.failureOrNull,
                lessonTitle: currentState.lessonTitle,
              ),
            );
            return;
          }

          final summary = assessmentResult.dataOrNull!;
          if (summary.isCourseCompleted) {
            courseAssessment = summary;
          }
        }

        final lessonCompletion = completionResult.dataOrNull!;

        emit(
          SessionCompletedState(
            lessonId: currentState.lessonId,
            lessonTitle: currentState.lessonTitle,
            totalXpEarned: lessonCompletion.totalXpWithBonus,
            accuracyPercentage: lessonCompletion.accuracyPercentage,
            timeSpentSeconds: lessonCompletion.timeSpentSeconds,
            totalTasks: lessonCompletion.totalTasks,
            correctTasks: lessonCompletion.correctTasks,
            coinsAwarded: lessonCompletion.coinsAwarded,
            unlockedAchievements: lessonCompletion.unlockedAchievements,
            courseAssessment: courseAssessment,
          ),
        );
      } catch (e) {
        emit(
          SessionErrorState(
            type: LessonTaskSessionErrorType.generic,
            failure: AppFailure.fromException(e),
            lessonTitle: currentState.lessonTitle,
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
