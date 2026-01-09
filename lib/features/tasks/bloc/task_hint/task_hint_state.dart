part of 'task_hint_cubit.dart';

sealed class TaskHintState extends Equatable {
  const TaskHintState();

  @override
  List<Object> get props => [];
}

class TaskHintInitial extends TaskHintState {
  const TaskHintInitial();
}

class TaskHintLoading extends TaskHintState {
  const TaskHintLoading();
}

class TaskHintLoaded extends TaskHintState {
  final String hint;

  const TaskHintLoaded(this.hint);

  @override
  List<Object> get props => [hint];
}

class TaskHintError extends TaskHintState {
  final String message;

  const TaskHintError(this.message);

  @override
  List<Object> get props => [message];
}
