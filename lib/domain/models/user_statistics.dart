import 'package:codium/domain/models/models.dart';

class UserStatistics {
  final String userId;
  
  final int currentStreak;
  final int maxStreak;
  final int points;
  final DateTime lastActiveDate;

  final Map<String, UserCourseStatistics> courses; // courseId → статистика

  int get totalSolvedTasks => courses.values
    .fold(0, (sum, course) => sum + course.solvedTasks);

  Duration get totalLearningTime => courses.values
    .fold(Duration.zero, (sum, course) => sum + course.timeSpent);

  UserStatistics({
    required this.userId,
    required this.currentStreak,
    required this.maxStreak,
    required this.lastActiveDate,
    required this.courses,
    required this.points,
  });
}