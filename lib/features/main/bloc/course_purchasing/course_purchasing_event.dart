part of 'course_purchasing_bloc.dart';

sealed class CoursePurchasingEvent extends Equatable {
  const CoursePurchasingEvent();

  @override
  List<Object> get props => [];
}

class CoursePurchasingRequestEvent extends CoursePurchasingEvent {
  final String courseId;

  const CoursePurchasingRequestEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}