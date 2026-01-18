import 'package:equatable/equatable.dart';

class CreateTaskProgressModel extends Equatable {
  final int taskId;
  final String userId;
  final bool isCompleted;
  final int attempts;
  final int hintsUsed;
  final int xpEarned;
  final String? userAnswer;
  final DateTime? completedAt;
  final DateTime lastAttemptAt;

  const CreateTaskProgressModel({
    required this.taskId,
    required this.userId,
    this.isCompleted = false,
    this.attempts = 1,
    this.hintsUsed = 0,
    required this.xpEarned,
    this.userAnswer,
    this.completedAt,
    required this.lastAttemptAt,
  });

  @override
  List<Object?> get props => [
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
