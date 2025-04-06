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
}
