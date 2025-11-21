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
  final List<Course> filteredCourses;
  final String searchQuery;

  const MainCoursesLoadSuccessState(
    this.courses, {
    List<Course>? filteredCourses,
    this.searchQuery = '',
  }) : filteredCourses = filteredCourses ?? courses;

  MainCoursesLoadSuccessState copyWith({
    List<Course>? courses,
    List<Course>? filteredCourses,
    String? searchQuery,
  }) {
    return MainCoursesLoadSuccessState(
      courses ?? this.courses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [courses, filteredCourses, searchQuery];
}
