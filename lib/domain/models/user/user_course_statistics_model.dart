import 'package:equatable/equatable.dart';

class UserCourseStatisticsModel extends Equatable {
  final int courseId;

  final double progress;
  final int totalLessons;
  final int completedLessons;

  final Duration timeSpent;
  final DateTime? lastActivity;

  const UserCourseStatisticsModel({
    required this.courseId,
    required this.progress,
    required this.totalLessons,
    required this.completedLessons,
    required this.timeSpent,
    required this.lastActivity,
  });

  bool get isCompleted => progress >= 100;

  UserCourseStatisticsModel copyWith({
    int? courseId,
    double? progress,
    int? totalLessons,
    int? completedLessons,
    Duration? timeSpent,
    DateTime? lastActivity,
  }) {
    return UserCourseStatisticsModel(
      courseId: courseId ?? this.courseId,
      progress: progress ?? this.progress,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      timeSpent: timeSpent ?? this.timeSpent,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  @override
  List<Object?> get props => [
    courseId,
    progress,
    totalLessons,
    completedLessons,
    timeSpent,
    lastActivity,
  ];
}
