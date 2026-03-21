part of 'learning_bloc.dart';

sealed class LearningState extends Equatable {
  const LearningState();

  @override
  List<Object> get props => [];
}

final class LearningLoadingState extends LearningState {
  const LearningLoadingState();
}

final class LearningLoadSuccessState extends LearningState {
  final List<DateTime> activityData;
  final List<CourseModel> enrolledCourses;
  final Map<int, UserCourseStatistics> courseStatistics;

  const LearningLoadSuccessState({
    required this.activityData,
    required this.enrolledCourses,
    required this.courseStatistics,
  });

  @override
  List<Object> get props => [activityData, enrolledCourses, courseStatistics];
}

final class LearningLoadErrorState extends LearningState {
  final AppFailure failure;

  const LearningLoadErrorState({required this.failure});

  @override
  List<Object> get props => [failure];
}
