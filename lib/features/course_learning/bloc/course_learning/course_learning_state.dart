part of 'course_learning_bloc.dart';

abstract class CourseLearningState extends Equatable {
  const CourseLearningState();

  @override
  List<Object?> get props => [];
}

class CourseLearningInitial extends CourseLearningState {
  const CourseLearningInitial();
}

class CourseLearningLoading extends CourseLearningState {
  const CourseLearningLoading();
}

class CourseLearningLoaded extends CourseLearningState {
  final CourseModel course;
  final List<LessonProgressModel> lessonProgress;
  final UserCourseStatisticsModel statistics;

  const CourseLearningLoaded({
    required this.course,
    required this.lessonProgress,
    required this.statistics,
  });

  @override
  List<Object?> get props => [course, lessonProgress, statistics];
}

class CourseLearningError extends CourseLearningState {
  final String message;

  const CourseLearningError({required this.message});

  @override
  List<Object?> get props => [message];
}
