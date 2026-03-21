import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/models/user/user_course_statistics.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
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

  Future<void> _onLoadData(
    LearningLoadEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(const LearningLoadingState());
    try {
      final userId = event.userId;
      final statisticsResult = await _getLearningDataUseCase(userId);
      final coursesResult = await _getEnrolledCoursesUseCase(userId);

      if (statisticsResult.isFailure) {
        emit(LearningLoadErrorState(failure: statisticsResult.failureOrNull!));
        return;
      }

      if (coursesResult.isFailure) {
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
      emit(LearningLoadErrorState(failure: AppFailure.fromException(e)));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
