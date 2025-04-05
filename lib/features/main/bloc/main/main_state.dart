part of 'main_bloc.dart';

sealed class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

final class MainCoursesInitialState extends MainState {}

final class MainCoursesLoadingState extends MainState {}

final class MainCoursesLoadErrorState extends MainState {
  final String message;

  const MainCoursesLoadErrorState(this.message);

  @override
  List<Object> get props => [message];
}

final class MainCoursesLoadSuccessState extends MainState {
  final List<Course> courses;

  const MainCoursesLoadSuccessState(this.courses);

  @override
  List<Object> get props => [courses];
}
