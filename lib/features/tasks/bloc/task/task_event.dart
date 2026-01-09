part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTaskEvent extends TaskEvent {
  final int taskId;

  const LoadTaskEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class SubmitAnswerEvent extends TaskEvent {
  final String answer;

  const SubmitAnswerEvent(this.answer);

  @override
  List<Object> get props => [answer];
}

class RequestHintEvent extends TaskEvent {
  const RequestHintEvent();
}

class RetryTaskEvent extends TaskEvent {
  const RetryTaskEvent();
}
