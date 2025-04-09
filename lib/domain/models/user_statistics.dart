// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  UserStatistics copyWith({
    String? userId,
    int? currentStreak,
    int? maxStreak,
    int? points,
    DateTime? lastActiveDate,
    Map<String, UserCourseStatistics>? courses,
  }) {
    return UserStatistics(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      points: points ?? this.points,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      courses: courses ?? this.courses,
    );
  }
}
