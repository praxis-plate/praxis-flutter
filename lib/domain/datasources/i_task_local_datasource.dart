import 'package:codium/data/database/app_database.dart';

abstract interface class ITaskLocalDataSource {
  Future<List<TaskEntity>> getTasksByLessonId(int lessonId);
  Future<TaskEntity?> getTaskById(int taskId);
  Future<TaskEntity> insertTask(TaskCompanion entry);
  Future<void> updateTask(TaskCompanion entry);

  Future<List<TaskProgressEntity>> getUserTaskProgress(
    int userId,
    int lessonId,
  );
  Future<TaskProgressEntity?> getTaskProgress(int userId, int taskId);
  Future<TaskProgressEntity> insertTaskProgress(TaskProgressCompanion entry);
  Future<void> updateTaskProgress(TaskProgressCompanion entry);

  Future<List<TaskOptionEntity>> getTaskOptions(int taskId);
  Future<List<TaskTestCaseEntity>> getTaskTestCases(int taskId);
}
