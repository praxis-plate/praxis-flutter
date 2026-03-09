part of 'main_carousel_bloc.dart';

sealed class MainCarouselState extends Equatable {
  const MainCarouselState();

  @override
  List<Object> get props => [];
}

final class MainCarouselInitialState extends MainCarouselState {}

final class MainCarouselLoadingState extends MainCarouselState {}

final class MainCarouselLoadErrorState extends MainCarouselState {
  final AppFailure failure;

  const MainCarouselLoadErrorState(this.failure);

  @override
  List<Object> get props => [failure];
}

final class MainCarouselLoadSuccessState extends MainCarouselState {
  final List<CourseModel> courses;

  const MainCarouselLoadSuccessState(this.courses);

  @override
  List<Object> get props => [courses];
}
