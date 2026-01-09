import 'package:equatable/equatable.dart';

class UpdateTaskProgressModel extends Equatable {
  final int id;
  final bool? isCompleted;
  final int? attempts;
  final int? hintsUsed;
  final int? xpEarned;
  final String? userAnswer;
  final DateTime? completedAt;
  final DateTime? lastAttemptAt;

  const UpdateTaskProgressModel({
    required this.id,
    this.isCompleted,
    this.attempts,
    this.hintsUsed,
    this.xpEarned,
    this.userAnswer,
    this.completedAt,
    this.lastAttemptAt,
  });

  @override
  List<Object?> get props => [
    id,
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
