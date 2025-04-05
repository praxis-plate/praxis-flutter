part of 'recommend_bloc.dart';

sealed class RecommendState extends Equatable {
  const RecommendState();

  @override
  List<Object> get props => [];
}

final class RecommendInitialState extends RecommendState {}

final class RecommendLoadingState extends RecommendState {}

final class RecommendLoadSuccessState extends RecommendState {
  final List<UserCourseStatistics> recommendCoursesStatistics;

  const RecommendLoadSuccessState({required this.recommendCoursesStatistics});

  @override
  List<Object> get props => [recommendCoursesStatistics];
}

final class RecommendLoadErrorState extends RecommendState {
  final String message;

  const RecommendLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
