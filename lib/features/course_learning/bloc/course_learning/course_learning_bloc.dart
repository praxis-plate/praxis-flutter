import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:praxis/domain/models/user/user_course_statistics.dart';
import 'package:praxis/domain/usecases/course/get_course_detail_usecase.dart';
import 'package:praxis/domain/usecases/lesson/get_course_lesson_progress_usecase.dart';
import 'package:praxis/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
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
  final GetLessonsByCourseIdUseCase _getLessonsByCourseIdUseCase;

  int? _currentCourseId;
  String? _currentUserId;

  CourseLearningBloc({
    required GetCourseDetailUseCase getCourseDetailUseCase,
    required GetCourseLessonProgressUseCase getCourseLessonProgressUseCase,
    required GetLessonsByCourseIdUseCase getLessonsByCourseIdUseCase,
  }) : _getCourseDetailUseCase = getCourseDetailUseCase,
       _getCourseLessonProgressUseCase = getCourseLessonProgressUseCase,
       _getLessonsByCourseIdUseCase = getLessonsByCourseIdUseCase,
       super(const CourseLearningInitial()) {
    on<LoadCourseLearning>(_onLoadCourseLearning);
    on<RefreshProgress>(_onRefreshProgress);
  }

  UserCourseStatistics _createStatistics(
    List<LessonProgressModel> progress,
    int totalLessons,
    String courseId,
  ) {
    final completedCount = progress.where((p) => p.isCompleted).length;
    final totalCount = totalLessons > 0
        ? totalLessons
        : (progress.isNotEmpty ? progress.length : 1);
    final progressPercent = (completedCount / totalCount) * 100;

    return UserCourseStatistics(
      courseId: courseId,
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
        final lessonsResult = await _getLessonsByCourseIdUseCase(
          event.courseId,
        );
        final totalLessons = lessonsResult.dataOrNull?.length ?? 0;

        if (course != null) {
          emit(
            CourseLearningLoaded(
              course: course,
              lessonProgress: progress,
              statistics: _createStatistics(
                progress,
                totalLessons,
                course.id.toString(),
              ),
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
        final lessonsResult = await _getLessonsByCourseIdUseCase(
          _currentCourseId!,
        );
        final totalLessons = lessonsResult.dataOrNull?.length ?? 0;

        if (course != null) {
          emit(
            CourseLearningLoaded(
              course: course,
              lessonProgress: progress,
              statistics: _createStatistics(
                progress,
                totalLessons,
                course.id.toString(),
              ),
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
