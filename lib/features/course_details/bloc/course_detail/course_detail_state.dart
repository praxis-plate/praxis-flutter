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
  final Course course;
  
  const CourseDetailLoadSuccessState({required this.course});

  @override
  List<Object> get props => [course];
}

class CourseDetailLoadErrorState extends CourseDetailState {
  final String message;
  
  const CourseDetailLoadErrorState(this.message);

  @override
  List<Object> get props => [message];
}