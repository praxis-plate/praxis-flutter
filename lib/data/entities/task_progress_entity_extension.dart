import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/task/create_task_progress_model.dart';
import 'package:codium/domain/models/task/task_progress_model.dart';
import 'package:codium/domain/models/task/update_task_progress_model.dart';
import 'package:drift/drift.dart';

extension TaskProgressEntityExtension on TaskProgressEntity {
  TaskProgressModel toDomain() {
    return TaskProgressModel(
      id: id,
      taskId: taskId,
      userId: userId,
      isCompleted: isCompleted,
      attempts: attempts,
      hintsUsed: hintsUsed,
      xpEarned: xpEarned,
      userAnswer: userAnswer,
      completedAt: completedAt,
      lastAttemptAt: lastAttemptAt,
    );
  }
}

extension CreateTaskProgressModelExtension on CreateTaskProgressModel {
  TaskProgressCompanion toCompanion() {
    return TaskProgressCompanion.insert(
      taskId: taskId,
      userId: userId,
      isCompleted: Value(isCompleted),
      attempts: Value(attempts),
      hintsUsed: Value(hintsUsed),
      xpEarned: Value(xpEarned),
      userAnswer: Value(userAnswer),
      completedAt: Value(completedAt),
      lastAttemptAt: lastAttemptAt,
    );
  }
}

extension UpdateTaskProgressModelExtension on UpdateTaskProgressModel {
  TaskProgressCompanion toCompanion() {
    return TaskProgressCompanion(
      id: Value(id),
      isCompleted: isCompleted != null
          ? Value(isCompleted!)
          : const Value.absent(),
      attempts: attempts != null ? Value(attempts!) : const Value.absent(),
      hintsUsed: hintsUsed != null ? Value(hintsUsed!) : const Value.absent(),
      xpEarned: xpEarned != null ? Value(xpEarned!) : const Value.absent(),
      userAnswer: userAnswer != null ? Value(userAnswer) : const Value.absent(),
      completedAt: completedAt != null
          ? Value(completedAt)
          : const Value.absent(),
      lastAttemptAt: lastAttemptAt != null
          ? Value(lastAttemptAt!)
          : const Value.absent(),
    );
  }
}
