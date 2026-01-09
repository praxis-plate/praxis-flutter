import 'package:equatable/equatable.dart';

class TaskProgressModel extends Equatable {
  final int id;
  final int taskId;
  final int userId;
  final bool isCompleted;
  final int attempts;
  final int hintsUsed;
  final int xpEarned;
  final String? userAnswer;
  final DateTime? completedAt;
  final DateTime lastAttemptAt;

  const TaskProgressModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.isCompleted,
    required this.attempts,
    required this.hintsUsed,
    required this.xpEarned,
    this.userAnswer,
    this.completedAt,
    required this.lastAttemptAt,
  });

  TaskProgressModel copyWith({
    int? id,
    int? taskId,
    int? userId,
    bool? isCompleted,
    int? attempts,
    int? hintsUsed,
    int? xpEarned,
    String? userAnswer,
    DateTime? completedAt,
    DateTime? lastAttemptAt,
  }) {
    return TaskProgressModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
      attempts: attempts ?? this.attempts,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      xpEarned: xpEarned ?? this.xpEarned,
      userAnswer: userAnswer ?? this.userAnswer,
      completedAt: completedAt ?? this.completedAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    taskId,
    userId,
    isCompleted,
    attempts,
    hintsUsed,
    xpEarned,
    userAnswer,
    completedAt,
    lastAttemptAt,
  ];

  @override
  bool get stringify => true;
}
