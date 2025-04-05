part of 'learning_bloc.dart';

sealed class LearningState extends Equatable {
  const LearningState();

  @override
  List<Object> get props => [];
}

final class LearningInitialState extends LearningState {}

final class LearningLoadingState extends LearningState {}

final class LearningLoadSuccessState extends LearningState {
  final List<ActivityCell> activityCells;
  final UserStatistics userStatistics;
  final List<UserCourseStatistics> addedCoursesStatistics;
  final List<UserCourseStatistics> passedCoursesStatistics;

  const LearningLoadSuccessState({
    required this.activityCells,
    required this.userStatistics,
    required this.addedCoursesStatistics,
    required this.passedCoursesStatistics,
  });

  @override
  List<Object> get props => [
        activityCells,
        userStatistics,
        addedCoursesStatistics,
        passedCoursesStatistics,
      ];
}

final class LearningLoadErrorState extends LearningState {
  final String message;

  const LearningLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
