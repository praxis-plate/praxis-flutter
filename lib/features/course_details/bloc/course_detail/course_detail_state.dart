part of 'course_detail_bloc.dart';

sealed class CourseDetailState extends Equatable {
  const CourseDetailState();
}

class CourseDetailInitialState extends CourseDetailState {
  @override
  List<Object> get props => [];
}

class CourseDetailLoadingState extends CourseDetailState {
  @override
  List<Object> get props => [];
}

class CourseDetailLoadSuccessState extends CourseDetailState {
  final CourseModel course;
  final bool isPurchased;

  const CourseDetailLoadSuccessState({
    required this.course,
    required this.isPurchased,
  });

  @override
  List<Object> get props => [course, isPurchased];
}

class CourseDetailLoadErrorState extends CourseDetailState {
  final String message;

  const CourseDetailLoadErrorState(this.message);

  @override
  List<Object> get props => [message];
}
