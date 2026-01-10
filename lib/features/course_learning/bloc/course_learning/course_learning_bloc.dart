import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/models/user/user_course_statistics_model.dart';
import 'package:codium/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_learning_event.dart';
part 'course_learning_state.dart';

class CourseLearningBloc
    extends Bloc<CourseLearningEvent, CourseLearningState> {
  final GetCourseByIdUseCase _getCourseByIdUseCase;
  final GetLessonsByCourseIdUseCase _getLessonsByCourseIdUseCase;
  final GetCourseLessonProgressUseCase _getCourseLessonProgressUseCase;
  final BuildCourseStatisticsUseCase _buildCourseStatisticsUseCase;

  int? _currentCourseId;
  int? _currentUserId;

  CourseLearningBloc({
    required GetCourseByIdUseCase getCourseByIdUseCase,
    required GetLessonsByCourseIdUseCase getLessonsByCourseIdUseCase,
    required GetCourseLessonProgressUseCase getCourseLessonProgressUseCase,
    required BuildCourseStatisticsUseCase buildCourseStatisticsUseCase,
  }) : _getCourseByIdUseCase = getCourseByIdUseCase,
       _getLessonsByCourseIdUseCase = getLessonsByCourseIdUseCase,
       _getCourseLessonProgressUseCase = getCourseLessonProgressUseCase,
       _buildCourseStatisticsUseCase = buildCourseStatisticsUseCase,
       super(const CourseLearningInitial()) {
    on<LoadCourseLearning>(_onLoadCourseLearning);
    on<RefreshProgress>(_onRefreshProgress);
  }

  Future<void> _onLoadCourseLearning(
    LoadCourseLearning event,
    Emitter<CourseLearningState> emit,
  ) async {
    emit(const CourseLearningLoading());
    try {
      _currentCourseId = event.courseId;
      _currentUserId = event.userId;

      final dataResult = await _loadCourseLearningData(
        courseId: event.courseId,
        userId: event.userId,
      );

      dataResult.when(
        success: (data) {
          emit(
            CourseLearningLoaded(
              course: data.course,
              lessonProgress: data.progress,
              statistics: _buildCourseStatisticsUseCase(
                courseId: data.course.id,
                progress: data.progress,
                totalLessons: data.totalLessons,
              ),
            ),
          );
        },
        failure: (failure) {
          emit(CourseLearningError(message: failure.message));
        },
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(CourseLearningError(message: e.toString()));
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
      final dataResult = await _loadCourseLearningData(
        courseId: _currentCourseId!,
        userId: _currentUserId!,
      );

      if (!dataResult.isSuccess) {
        return;
      }

      final data = dataResult.dataOrNull!;
      emit(
        CourseLearningLoaded(
          course: data.course,
          lessonProgress: data.progress,
          statistics: _buildCourseStatisticsUseCase(
            courseId: data.course.id,
            progress: data.progress,
            totalLessons: data.totalLessons,
          ),
        ),
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<Result<_CourseLearningData>> _loadCourseLearningData({
    required int courseId,
    required int userId,
  }) async {
    final courseResult = await _getCourseByIdUseCase(courseId);
    if (!courseResult.isSuccess) {
      return Failure(courseResult.failureOrNull!);
    }

    final progressResult = await _getCourseLessonProgressUseCase(
      userId,
      courseId,
    );
    if (!progressResult.isSuccess) {
      return Failure(progressResult.failureOrNull!);
    }

    final lessonsResult = await _getLessonsByCourseIdUseCase(courseId);
    if (!lessonsResult.isSuccess) {
      return Failure(lessonsResult.failureOrNull!);
    }

    final course = courseResult.dataOrNull;
    if (course == null) {
      return const Failure(
        AppFailure(
          code: AppErrorCode.apiNotFound,
          message: 'Course not found',
          canRetry: false,
        ),
      );
    }

    final progress = progressResult.dataOrNull!;
    final lessons = lessonsResult.dataOrNull!;
    final totalLessons = lessons.length;

    return Success(
      _CourseLearningData(
        course: course,
        progress: progress,
        totalLessons: totalLessons,
      ),
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}

class _CourseLearningData extends Equatable {
  final CourseModel course;
  final List<LessonProgressModel> progress;
  final int totalLessons;

  const _CourseLearningData({
    required this.course,
    required this.progress,
    required this.totalLessons,
  });

  @override
  List<Object?> get props => [course, progress, totalLessons];
}
