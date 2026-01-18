part of 'lesson_task_session_bloc.dart';

abstract class LessonTaskSessionState extends Equatable {
  const LessonTaskSessionState();

  @override
  List<Object> get props => [];
}

class SessionInitialState extends LessonTaskSessionState {
  const SessionInitialState();
}

class SessionLoadingState extends LessonTaskSessionState {
  const SessionLoadingState();
}

class SessionActiveState extends LessonTaskSessionState {
  final int lessonId;
  final String userId;
  final List<TaskModel> tasks;
  final int currentTaskIndex;
  final int completedTasksCount;
  final int correctTasksCount;
  final int totalXpEarned;
  final DateTime sessionStartTime;

  const SessionActiveState({
    required this.lessonId,
    required this.userId,
    required this.tasks,
    required this.currentTaskIndex,
    required this.completedTasksCount,
    required this.correctTasksCount,
    required this.totalXpEarned,
    required this.sessionStartTime,
  });

  TaskModel get currentTask => tasks[currentTaskIndex];

  bool get isLastTask => currentTaskIndex >= tasks.length - 1;

  double get accuracy =>
      completedTasksCount > 0 ? correctTasksCount / completedTasksCount : 0.0;

  SessionActiveState copyWith({
    int? currentTaskIndex,
    int? completedTasksCount,
    int? correctTasksCount,
    int? totalXpEarned,
  }) {
    return SessionActiveState(
      lessonId: lessonId,
      userId: userId,
      tasks: tasks,
      currentTaskIndex: currentTaskIndex ?? this.currentTaskIndex,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      correctTasksCount: correctTasksCount ?? this.correctTasksCount,
      totalXpEarned: totalXpEarned ?? this.totalXpEarned,
      sessionStartTime: sessionStartTime,
    );
  }

  @override
  List<Object> get props => [
    lessonId,
    userId,
    tasks,
    currentTaskIndex,
    completedTasksCount,
    correctTasksCount,
    totalXpEarned,
    sessionStartTime,
  ];
}

class SessionCompletedState extends LessonTaskSessionState {
  final int lessonId;
  final int totalXpEarned;
  final double accuracyPercentage;
  final int timeSpentSeconds;
  final int totalTasks;
  final int correctTasks;

  const SessionCompletedState({
    required this.lessonId,
    required this.totalXpEarned,
    required this.accuracyPercentage,
    required this.timeSpentSeconds,
    required this.totalTasks,
    required this.correctTasks,
  });

  @override
  List<Object> get props => [
    lessonId,
    totalXpEarned,
    accuracyPercentage,
    timeSpentSeconds,
    totalTasks,
    correctTasks,
  ];
}

class SessionErrorState extends LessonTaskSessionState {
  final String message;

  const SessionErrorState(this.message);

  @override
  List<Object> get props => [message];
}
