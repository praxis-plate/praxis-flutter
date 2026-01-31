import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/models/user/user_course_statistics.dart';
import 'package:codium/domain/usecases/course/get_course_detail_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_learning_event.dart';
part 'course_learning_state.dart';

class CourseLearningBloc
    extends Bloc<CourseLearningEvent, CourseLearningState> {
  final GetCourseDetailUseCase _getCourseDetailUseCase;

  int? _currentCourseId;
  String? _currentUserId;

  CourseLearningBloc({required GetCourseDetailUseCase getCourseDetailUseCase})
    : _getCourseDetailUseCase = getCourseDetailUseCase,
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
        // For now, we'll use empty progress list until lesson progress use case is implemented
        final progress = <LessonProgressModel>[];

        if (course != null) {
          emit(
            CourseLearningLoaded(
              course: course,
              lessonProgress: progress,
              statistics: _createStatistics(course, progress),
            ),
          );
        } else {
          emit(const CourseLearningError(message: 'Course not found'));
        }
      } else {
        final error = courseResult.failureOrNull;
        emit(CourseLearningError(message: error?.message ?? 'Unknown error'));
      }
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
      final courseResult = await _getCourseDetailUseCase.call(
        _currentCourseId!,
      );

      if (courseResult.isSuccess) {
        final course = courseResult.dataOrNull;
        // For now, we'll use empty progress list until lesson progress use case is implemented
        final progress = <LessonProgressModel>[];

        if (course != null) {
          emit(
            CourseLearningLoaded(
              course: course,
              lessonProgress: progress,
              statistics: _createStatistics(course, progress),
            ),
          );
        }
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
