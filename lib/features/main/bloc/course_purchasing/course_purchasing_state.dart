part of 'course_purchasing_bloc.dart';

sealed class CoursePurchasingState extends Equatable {
  const CoursePurchasingState();

  @override
  List<Object> get props => [];
}

class CoursePurchasingInitialState extends CoursePurchasingState {
  @override
  List<Object> get props => [];
}

class CoursePurchasingLoadingState extends CoursePurchasingState {
  final String courseId;

  const CoursePurchasingLoadingState(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class CoursePurchasingLoadSuccessState extends CoursePurchasingState {
  final String courseId;

  const CoursePurchasingLoadSuccessState(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class CoursePurchasingLoadErrorState extends CoursePurchasingState {
  final String courseId;
  final String error;

  const CoursePurchasingLoadErrorState(this.courseId, this.error);

  @override
  List<Object> get props => [courseId, error];
}
