part of 'lesson_task_session_bloc.dart';

abstract class LessonTaskSessionEvent extends Equatable {
  const LessonTaskSessionEvent();

  @override
  List<Object> get props => [];
}

class StartSessionEvent extends LessonTaskSessionEvent {
  final int lessonId;
  final String userId;

  const StartSessionEvent({required this.lessonId, required this.userId});

  @override
  List<Object> get props => [lessonId, userId];
}

class CompleteCurrentTaskEvent extends LessonTaskSessionEvent {
  final bool isCorrect;
  final int xpEarned;

  const CompleteCurrentTaskEvent({
    required this.isCorrect,
    required this.xpEarned,
  });

  @override
  List<Object> get props => [isCorrect, xpEarned];
}

class ExitSessionEvent extends LessonTaskSessionEvent {
  final bool saveProgress;

  const ExitSessionEvent({this.saveProgress = false});

  @override
  List<Object> get props => [saveProgress];
}
