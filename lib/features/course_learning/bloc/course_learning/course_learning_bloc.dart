import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/models/user/user_course_statistics.dart';
import 'package:codium/domain/usecases/course/get_course_detail_usecase.dart';
import 'package:codium/domain/usecases/lesson/get_course_lesson_progress_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_learning_event.dart';
part 'course_learning_state.dart';

class CourseLearningBloc
    extends Bloc<CourseLearningEvent, CourseLearningState> {
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final GetCourseLessonProgressUseCase _getCourseLessonProgressUseCase;

  int? _currentCourseId;
  String? _currentUserId;

  CourseLearningBloc({
    required GetCourseDetailUseCase getCourseDetailUseCase,
    required GetCourseLessonProgressUseCase getCourseLessonProgressUseCase,
  }) : _getCourseDetailUseCase = getCourseDetailUseCase,
       _getCourseLessonProgressUseCase = getCourseLessonProgressUseCase,
      super(const CourseLearningInitial()) {
    on<LoadCourseLearning>(_onLoadCourseLearning);
    on<RefreshProgress>(_onRefreshProgress);
  }

  UserCourseStatistics _createStatistics(
    CourseModel course,
    List<LessonProgressModel> progress,
  ) {
    final completedCount = progress.where((p) => p.isCompleted).length;
    final totalCount = course.totalTasks > 0 ? course.totalTasks : 1;
    final progressPercent = (completedCount / totalCount) * 100;

    return UserCourseStatistics(
      courseId: course.id.toString(),
      progress: progressPercent,
      totalTasks: totalCount,
      solvedTasks: completedCount,
      timeSpent: Duration.zero,
      lastActivity: DateTime.now(),
    );
  }

  Future<void> _onLoadCourseLearning(
    LoadCourseLearning event,
    Emitter<CourseLearningState> emit,
  ) async {
    emit(const CourseLearningLoading());
    try {
      _currentCourseId = event.courseId;
      _currentUserId = event.userId;

      final courseResult = await _getCourseDetailUseCase.call(event.courseId);

      if (courseResult.isSuccess) {
        final course = courseResult.dataOrNull;
        final progressResult = await _getCourseLessonProgressUseCase(
          userId: event.userId,
          courseId: event.courseId,
        );
        final progress = progressResult.dataOrNull ?? <LessonProgressModel>[];

        if (course != null) {
          emit(
            CourseLearningLoaded(
              course: course,
              lessonProgress: progress,
              statistics: _createStatistics(course, progress),
            ),
          );
        } else {
          emit(
            const CourseLearningError(
              failure: AppFailure(code: AppErrorCode.apiNotFound, message: ''),
            ),
          );
        }
      } else {
        final error = courseResult.failureOrNull;
        emit(
          CourseLearningError(
            failure:
                error ??
                AppFailure.fromException(
                  StateError('Failed to load course progress'),
                ),
          ),
        );
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(CourseLearningError(failure: AppFailure.fromException(e)));
    }
  }

  Future<void> _onRefreshProgress(
    RefreshProgress event,
    Emitter<CourseLearningState> emit,
  ) async {
    if (_currentCourseId == null || _currentUserId == null) {
      return;
    }

    try {
      final courseResult = await _getCourseDetailUseCase.call(
        _currentCourseId!,
      );

      if (courseResult.isSuccess) {
        final course = courseResult.dataOrNull;
        final progressResult = await _getCourseLessonProgressUseCase(
          userId: _currentUserId!,
          courseId: _currentCourseId!,
        );
        final progress = progressResult.dataOrNull ?? <LessonProgressModel>[];

        if (course != null) {
          emit(
            CourseLearningLoaded(
              course: course,
              lessonProgress: progress,
              statistics: _createStatistics(course, progress),
            ),
          );
        } else {
          emit(
            const CourseLearningError(
              failure: AppFailure(code: AppErrorCode.apiNotFound, message: ''),
            ),
          );
        }
      } else {
        emit(
          CourseLearningError(
            failure:
                courseResult.failureOrNull ??
                AppFailure.fromException(
                  StateError('Failed to refresh course progress'),
                ),
          ),
        );
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(CourseLearningError(failure: AppFailure.fromException(e)));
    }
  }
}
