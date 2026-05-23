import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:praxis/domain/models/user/user_course_statistics.dart';
import 'package:praxis/domain/usecases/usecases.dart';
import 'package:praxis/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'learning_event.dart';
part 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final GetLearningDataUseCase _getLearningDataUseCase;
  final GetEnrolledCoursesUseCase _getEnrolledCoursesUseCase;
  final GetCourseLessonProgressUseCase _getCourseLessonProgressUseCase;
  final GetLessonsByCourseIdUseCase _getLessonsByCourseIdUseCase;

  LearningBloc({
    required GetLearningDataUseCase getLearningDataUseCase,
    required GetEnrolledCoursesUseCase getEnrolledCoursesUseCase,
    required GetCourseLessonProgressUseCase getCourseLessonProgressUseCase,
    required GetLessonsByCourseIdUseCase getLessonsByCourseIdUseCase,
  }) : _getLearningDataUseCase = getLearningDataUseCase,
       _getEnrolledCoursesUseCase = getEnrolledCoursesUseCase,
       _getCourseLessonProgressUseCase = getCourseLessonProgressUseCase,
       _getLessonsByCourseIdUseCase = getLessonsByCourseIdUseCase,
       super(const LearningLoadingState()) {
    on<LearningLoadEvent>(_onLoadData);
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

  Future<String> resolveContinueRoute({
    required String userId,
    required CourseModel course,
  }) async {
    final lessonsResult = await _getLessonsByCourseIdUseCase(course.id);
    if (lessonsResult.isFailure) {
      return '/course/${course.id}/learn';
    }

    final lessons = List.of(lessonsResult.dataOrNull ?? [])
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    if (lessons.isEmpty) {
      return '/course/${course.id}/learn';
    }

    final progressResult = await _getCourseLessonProgressUseCase(
      userId: userId,
      courseId: course.id,
    );
    final progress = progressResult.dataOrNull ?? <LessonProgressModel>[];
    final completedLessonIds = progress
        .where((item) => item.isCompleted)
        .map((item) => item.lessonId)
        .toSet();

    for (final lesson in lessons) {
      if (!completedLessonIds.contains(lesson.id)) {
        return '/lesson/${lesson.id}?courseId=${course.id}';
      }
    }

    return '/course/${course.id}/learn';
  }

  Future<void> _onLoadData(
    LearningLoadEvent event,
    Emitter<LearningState> emit,
  ) async {
    final previousSuccess = state is LearningLoadSuccessState
        ? state as LearningLoadSuccessState
        : null;

    if (previousSuccess == null) {
      emit(const LearningLoadingState());
    }

    try {
      final userId = event.userId;
      final statisticsResult = await _getLearningDataUseCase(userId);
      final coursesResult = await _getEnrolledCoursesUseCase(userId);

      if (statisticsResult.isFailure) {
        if (previousSuccess != null) {
          emit(previousSuccess);
          return;
        }
        emit(LearningLoadErrorState(failure: statisticsResult.failureOrNull!));
        return;
      }

      if (coursesResult.isFailure) {
        if (previousSuccess != null) {
          emit(previousSuccess);
          return;
        }
        emit(LearningLoadErrorState(failure: coursesResult.failureOrNull!));
        return;
      }

      final courses = coursesResult.dataOrNull ?? [];
      final statisticsEntries = await Future.wait(
        courses.map((course) async {
          final progressResult = await _getCourseLessonProgressUseCase(
            userId: userId,
            courseId: course.id,
          );
          final progress = progressResult.dataOrNull ?? <LessonProgressModel>[];
          final lessonsResult = await _getLessonsByCourseIdUseCase(course.id);
          final totalLessons = lessonsResult.dataOrNull?.length ?? 0;
          return MapEntry(
            course.id,
            _createStatistics(progress, totalLessons, course.id.toString()),
          );
        }),
      );

      emit(
        LearningLoadSuccessState(
          activityData: const [],
          enrolledCourses: courses,
          courseStatistics: {
            for (final entry in statisticsEntries) entry.key: entry.value,
          },
        ),
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      if (previousSuccess != null) {
        emit(previousSuccess);
        return;
      }
      emit(LearningLoadErrorState(failure: AppFailure.fromException(e)));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
