part of 'lesson_task_session_bloc.dart';

abstract class LessonTaskSessionState extends Equatable {
  const LessonTaskSessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitialState extends LessonTaskSessionState {
  const SessionInitialState();
}

class SessionLoadingState extends LessonTaskSessionState {
  final String? lessonTitle;

  const SessionLoadingState({this.lessonTitle});

  @override
  List<Object?> get props => [lessonTitle];
}

class SessionActiveState extends LessonTaskSessionState {
  final int lessonId;
  final String userId;
  final String lessonTitle;
  final List<TaskModel> tasks;
  final int currentTaskIndex;
  final int completedTasksCount;
  final int correctTasksCount;
  final int totalXpEarned;
  final DateTime sessionStartTime;

  const SessionActiveState({
    required this.lessonId,
    required this.userId,
    required this.lessonTitle,
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
    String? lessonTitle,
    int? currentTaskIndex,
    int? completedTasksCount,
    int? correctTasksCount,
    int? totalXpEarned,
  }) {
    return SessionActiveState(
      lessonId: lessonId,
      userId: userId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
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
    lessonTitle,
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
  final String lessonTitle;
  final int totalXpEarned;
  final double accuracyPercentage;
  final int timeSpentSeconds;
  final int totalTasks;
  final int correctTasks;
  final bool isPersisting;

  const SessionCompletedState({
    required this.lessonId,
    required this.lessonTitle,
    required this.totalXpEarned,
    required this.accuracyPercentage,
    required this.timeSpentSeconds,
    required this.totalTasks,
    required this.correctTasks,
    this.isPersisting = false,
  });

  @override
  List<Object> get props => [
    lessonId,
    lessonTitle,
    totalXpEarned,
    accuracyPercentage,
    timeSpentSeconds,
    totalTasks,
    correctTasks,
    isPersisting,
  ];
}

enum LessonTaskSessionErrorType { noTasks, generic }

class SessionErrorState extends LessonTaskSessionState {
  final LessonTaskSessionErrorType type;
  final AppFailure? failure;
  final String? lessonTitle;

  const SessionErrorState({required this.type, this.failure, this.lessonTitle});

  @override
  List<Object?> get props => [type, failure, lessonTitle];
}
