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

  const LearningLoadSuccessState({
    required this.activityData,
    required this.enrolledCourses,
  });

  @override
  List<Object> get props => [activityData, enrolledCourses];
}

final class LearningLoadErrorState extends LearningState {
  final String message;

  const LearningLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
