import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/course/course_assessment_model.dart';
import 'package:praxis/domain/repositories/i_lesson_progress_repository.dart';
import 'package:praxis/domain/repositories/i_lesson_repository.dart';
import 'package:praxis/domain/repositories/i_task_repository.dart';

class GetCourseAssessmentUseCase {
  final ILessonRepository _lessonRepository;
  final ILessonProgressRepository _lessonProgressRepository;
  final ITaskRepository _taskRepository;

  const GetCourseAssessmentUseCase({
    required ILessonRepository lessonRepository,
    required ILessonProgressRepository lessonProgressRepository,
    required ITaskRepository taskRepository,
  }) : _lessonRepository = lessonRepository,
       _lessonProgressRepository = lessonProgressRepository,
       _taskRepository = taskRepository;

  Future<Result<CourseAssessmentModel>> call({
    required String userId,
    required int courseId,
  }) async {
    final lessonsResult = await _lessonRepository.getLessonsByCourseId(
      courseId,
    );
    if (lessonsResult.isFailure) {
      return Failure(lessonsResult.failureOrNull!);
    }

    final progressResult = await _lessonProgressRepository
        .getCourseLessonProgress(userId, courseId);
    if (progressResult.isFailure) {
      return Failure(progressResult.failureOrNull!);
    }

    final lessons = lessonsResult.dataOrNull!;
    final progress = progressResult.dataOrNull!;
    if (lessons.isEmpty) {
      return const Failure(
        AppFailure(
          code: AppErrorCode.apiNotFound,
          message: 'Course has no lessons',
          canRetry: false,
        ),
      );
    }

    var totalTasks = 0;
    var completedTasks = 0;

    for (final lesson in lessons) {
      final taskCountResult = await _taskRepository.getTasksByLessonId(
        lesson.id,
      );
      if (taskCountResult.isFailure) {
        return Failure(taskCountResult.failureOrNull!);
      }
      totalTasks += taskCountResult.dataOrNull!.length;

      final completedCountResult = await _taskRepository.getCompletedTaskCount(
        userId,
        lesson.id,
      );
      if (completedCountResult.isFailure) {
        return Failure(completedCountResult.failureOrNull!);
      }
      completedTasks += completedCountResult.dataOrNull!;
    }

    final completedLessons = progress
        .where((item) => item.isCompleted)
        .map((item) => item.lessonId)
        .toSet()
        .length;
    final accuracyPercentage = totalTasks == 0
        ? 100.0
        : (completedTasks / totalTasks) * 100;

    return Success(
      CourseAssessmentModel(
        totalLessons: lessons.length,
        completedLessons: completedLessons,
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        accuracyPercentage: accuracyPercentage,
        grade: _resolveGrade(accuracyPercentage),
      ),
    );
  }

  int _resolveGrade(double accuracyPercentage) {
    if (accuracyPercentage >= 90) {
      return 5;
    }
    if (accuracyPercentage >= 75) {
      return 4;
    }
    if (accuracyPercentage >= 60) {
      return 3;
    }
    return 2;
  }
}
