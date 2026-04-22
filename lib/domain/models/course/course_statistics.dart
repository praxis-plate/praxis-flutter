import 'package:praxis/domain/enums/task_type.dart';
import 'package:equatable/equatable.dart';

class CourseStatistics extends Equatable {
  final double averageRating;
  final int totalEnrollments;
  final double completionRate;
  final Map<TaskType, Duration> averageCompletionTime;

  const CourseStatistics({
    required this.averageRating,
    required this.totalEnrollments,
    required this.completionRate,
    this.averageCompletionTime = const {},
  });

  @override
  List<Object?> get props => [
    averageRating,
    totalEnrollments,
    completionRate,
    averageCompletionTime,
  ];

  @override
  bool get stringify => true;
}
