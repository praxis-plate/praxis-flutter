part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

abstract interface class TaskStateWithTask {
  TaskModel get task;
}

class TaskInitialState extends TaskState {
  const TaskInitialState();
}

class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}

class TaskLoadedState extends TaskState implements TaskStateWithTask {
  @override
  final TaskModel task;
  final TaskProgressModel? progress;

  const TaskLoadedState({required this.task, this.progress});

  @override
  List<Object?> get props => [task, progress];
}

class TaskAnswerValidatingState extends TaskState implements TaskStateWithTask {
  @override
  final TaskModel task;

  const TaskAnswerValidatingState(this.task);

  @override
  List<Object> get props => [task];
}

class TaskAnswerCorrectState extends TaskState implements TaskStateWithTask {
  @override
  final TaskModel task;
  final TaskResultModel result;

  const TaskAnswerCorrectState({required this.task, required this.result});

  @override
  List<Object> get props => [task, result];
}

class TaskAnswerIncorrectState extends TaskState implements TaskStateWithTask {
  @override
  final TaskModel task;
  final TaskResultModel result;

  const TaskAnswerIncorrectState({required this.task, required this.result});

  @override
  List<Object> get props => [task, result];
}

class TaskHintLoadingState extends TaskState implements TaskStateWithTask {
  @override
  final TaskModel task;

  const TaskHintLoadingState(this.task);

  @override
  List<Object> get props => [task];
}

class TaskHintLoadedState extends TaskState implements TaskStateWithTask {
  @override
  final TaskModel task;
  final String hint;
  final int hintsUsed;

  const TaskHintLoadedState({
    required this.task,
    required this.hint,
    required this.hintsUsed,
  });

  @override
  List<Object> get props => [task, hint, hintsUsed];
}

class TaskErrorState extends TaskState {
  final AppFailure failure;

  const TaskErrorState(this.failure);

  @override
  List<Object> get props => [failure];
}

class TaskHintErrorState extends TaskState implements TaskStateWithTask {
  @override
  final TaskModel task;
  final AppFailure failure;

  const TaskHintErrorState({required this.task, required this.failure});

  @override
  List<Object> get props => [task, failure];
}
