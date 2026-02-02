part of 'lessons_list_bloc.dart';

sealed class LessonsListEvent extends Equatable {
  const LessonsListEvent();

  @override
  List<Object> get props => [];
}

final class LoadLessonsListEvent extends LessonsListEvent {
  final int courseId;

  const LoadLessonsListEvent({required this.courseId});

  @override
  List<Object> get props => [courseId];
}
