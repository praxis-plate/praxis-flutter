part of 'course_detail_bloc.dart';

sealed class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();
}

class CourseDetailLoadEvent extends CourseDetailEvent {
  final String courseId;
  
  const CourseDetailLoadEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}
