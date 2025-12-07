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
  final List<CourseModel> courses;
  final List<CourseModel> filteredCourses;
  final String searchQuery;
  final Set<int> enrolledCourseIds;

  const MainCoursesLoadSuccessState(
    this.courses,
    this.enrolledCourseIds, {
    List<CourseModel>? filteredCourses,
    this.searchQuery = '',
  }) : filteredCourses = filteredCourses ?? courses;

  MainCoursesLoadSuccessState copyWith({
    List<CourseModel>? courses,
    Set<int>? enrolledCourseIds,
    List<CourseModel>? filteredCourses,
    String? searchQuery,
  }) {
    return MainCoursesLoadSuccessState(
      courses ?? this.courses,
      enrolledCourseIds ?? this.enrolledCourseIds,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    courses,
    filteredCourses,
    searchQuery,
    enrolledCourseIds,
  ];
}
