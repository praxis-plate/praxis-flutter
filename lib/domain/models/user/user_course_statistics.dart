class UserCourseStatistics {
  final String courseId;

  final double progress;
  final int totalTasks;
  final int solvedTasks;

  final Duration timeSpent;
  final DateTime lastActivity;

  UserCourseStatistics({
    required this.courseId,
    required this.progress,
    required this.totalTasks,
    required this.solvedTasks,
    required this.timeSpent,
    required this.lastActivity,
  });

  bool get isCompleted => progress >= 100;

  UserCourseStatistics copyWith({
    String? courseId,
    double? progress,
    int? totalTasks,
    int? solvedTasks,
    Duration? timeSpent,
    DateTime? lastActivity,
  }) {
    return UserCourseStatistics(
      courseId: courseId ?? this.courseId,
      progress: progress ?? this.progress,
      totalTasks: totalTasks ?? this.totalTasks,
      solvedTasks: solvedTasks ?? this.solvedTasks,
      timeSpent: timeSpent ?? this.timeSpent,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
