part of 'course_detail_bloc.dart';

sealed class CourseDetailState extends Equatable {
  const CourseDetailState();
}

class CourseDetailLoadingState extends CourseDetailState {
  @override
  List<Object> get props => [];
}

class CourseDetailLoadSuccessState extends CourseDetailState {
  final CourseModel course;
  final bool isPurchased;
  final CourseStructureModel? tableOfContents;

  const CourseDetailLoadSuccessState({
    required this.course,
    required this.isPurchased,
    this.tableOfContents,
  });

  @override
  List<Object?> get props => [course, isPurchased, tableOfContents];
}

class CourseDetailLoadErrorState extends CourseDetailState {
  final AppFailure failure;

  const CourseDetailLoadErrorState(this.failure);

  @override
  List<Object> get props => [failure];
}
