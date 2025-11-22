import 'package:codium/domain/enums/task_type.dart';

class CourseStatistics {
  final double averageRating;
  final int totalEnrollments;
  final double completionRate;
  final Map<TaskType, Duration> averageCompletionTime;

  CourseStatistics({
    required this.averageRating,
    required this.totalEnrollments,
    required this.completionRate,
    this.averageCompletionTime = const {},
  });
}
