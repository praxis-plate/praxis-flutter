part of 'lessons_list_bloc.dart';

sealed class LessonsListState extends Equatable {
  const LessonsListState();

  @override
  List<Object> get props => [];
}

final class LessonsListInitialState extends LessonsListState {
  const LessonsListInitialState();
}

final class LessonsListLoadingState extends LessonsListState {
  const LessonsListLoadingState();
}

final class LessonsListLoadedState extends LessonsListState {
  final List<LessonModel> lessons;
  final Map<int, int?> taskCounts;

  const LessonsListLoadedState({
    required this.lessons,
    required this.taskCounts,
  });

  @override
  List<Object> get props => [lessons, taskCounts];
}

final class LessonsListErrorState extends LessonsListState {
  final String message;

  const LessonsListErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
