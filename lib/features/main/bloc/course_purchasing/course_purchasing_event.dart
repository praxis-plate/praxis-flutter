part of 'course_purchasing_bloc.dart';

sealed class CoursePurchasingEvent extends Equatable {
  const CoursePurchasingEvent();

  @override
  List<Object> get props => [];
}

class CoursePurchasingRequestEvent extends CoursePurchasingEvent {
  final int userId;
  final int courseId;

  const CoursePurchasingRequestEvent({
    required this.userId,
    required this.courseId,
  });

  @override
  List<Object> get props => [userId, courseId];
}
