part of 'course_learning_bloc.dart';

abstract class CourseLearningEvent extends Equatable {
  const CourseLearningEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourseLearning extends CourseLearningEvent {
  final int courseId;
  final String userId;

  const LoadCourseLearning({required this.courseId, required this.userId});

  @override
  List<Object?> get props => [courseId, userId];
}

class RefreshProgress extends CourseLearningEvent {
  const RefreshProgress();
}
