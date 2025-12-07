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
  final String message;

  const RecommendLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
