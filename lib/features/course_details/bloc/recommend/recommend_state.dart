part of 'recommend_bloc.dart';

sealed class RecommendState extends Equatable {
  const RecommendState();

  @override
  List<Object> get props => [];
}

final class RecommendInitialState extends RecommendState {}

final class RecommendLoadingState extends RecommendState {}

final class RecommendLoadSuccessState extends RecommendState {
  final List<CourseModel> recommendCourses;

  const RecommendLoadSuccessState({required this.recommendCourses});

  @override
  List<Object> get props => [recommendCourses];
}

final class RecommendLoadErrorState extends RecommendState {
  final AppFailure failure;

  const RecommendLoadErrorState({required this.failure});

  @override
  List<Object> get props => [failure];
}
