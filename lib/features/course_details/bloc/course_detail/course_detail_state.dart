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
  final CourseStructureDto? tableOfContents;

  const CourseDetailLoadSuccessState({
    required this.course,
    required this.isPurchased,
    this.tableOfContents,
  });

  @override
  List<Object?> get props => [course, isPurchased, tableOfContents];
}

class CourseDetailLoadErrorState extends CourseDetailState {
  final String message;

  const CourseDetailLoadErrorState(this.message);

  @override
  List<Object> get props => [message];
}
