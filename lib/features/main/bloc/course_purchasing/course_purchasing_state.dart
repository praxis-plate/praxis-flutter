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
  final int courseId;

  const CoursePurchasingLoadingState(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class CoursePurchasingLoadSuccessState extends CoursePurchasingState {
  final int courseId;

  const CoursePurchasingLoadSuccessState(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class CoursePurchasingLoadErrorState extends CoursePurchasingState {
  final int courseId;
  final AppFailure failure;

  const CoursePurchasingLoadErrorState(this.courseId, this.failure);

  @override
  List<Object> get props => [courseId, failure];
}

class CoursePurchasingInsufficientBalanceState extends CoursePurchasingState {
  final int courseId;
  final int required;
  final int available;

  const CoursePurchasingInsufficientBalanceState(
    this.courseId, {
    required this.required,
    required this.available,
  });

  @override
  List<Object> get props => [courseId, required, available];
}
