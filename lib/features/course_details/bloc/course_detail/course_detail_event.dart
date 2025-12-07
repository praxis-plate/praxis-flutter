part of 'course_detail_bloc.dart';

sealed class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();
}

class CourseDetailLoadEvent extends CourseDetailEvent {
  final int courseId;
  final int userId;

  const CourseDetailLoadEvent({required this.courseId, required this.userId});

  @override
  List<Object> get props => [courseId, userId];
}
