import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/models/user/user_course_statistics_model.dart';

// TODO: Move to a domain service when statistics logic grows.
class BuildCourseStatisticsUseCase {
  const BuildCourseStatisticsUseCase();

  UserCourseStatisticsModel call({
    required int courseId,
    required List<LessonProgressModel> progress,
    required int totalLessons,
  }) {
    var completedCount = 0;
    var timeSpentSeconds = 0;
    DateTime? lastActivity;

    for (final item in progress) {
      if (item.isCompleted) {
        completedCount += 1;
      }
      timeSpentSeconds += item.timeSpentSeconds;
      final completedAt = item.completedAt;
      if (completedAt != null &&
          (lastActivity == null || completedAt.isAfter(lastActivity))) {
        lastActivity = completedAt;
      }
    }

    final progressPercent = (completedCount / totalLessons) * 100;

    return UserCourseStatisticsModel(
      courseId: courseId,
      progress: progressPercent,
      totalLessons: totalLessons,
      completedLessons: completedCount,
      timeSpent: Duration(seconds: timeSpentSeconds),
      lastActivity: lastActivity,
    );
  }
}
