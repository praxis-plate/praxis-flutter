import 'package:equatable/equatable.dart';

class CourseAssessmentModel extends Equatable {
  final int totalLessons;
  final int completedLessons;
  final int totalTasks;
  final int completedTasks;
  final double accuracyPercentage;
  final int grade;

  const CourseAssessmentModel({
    required this.totalLessons,
    required this.completedLessons,
    required this.totalTasks,
    required this.completedTasks,
    required this.accuracyPercentage,
    required this.grade,
  });

  bool get isCourseCompleted =>
      totalLessons > 0 && completedLessons >= totalLessons;

  @override
  List<Object?> get props => [
    totalLessons,
    completedLessons,
    totalTasks,
    completedTasks,
    accuracyPercentage,
    grade,
  ];

  @override
  bool get stringify => true;
}
