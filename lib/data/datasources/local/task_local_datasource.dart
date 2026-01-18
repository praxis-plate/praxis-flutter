import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_task_local_datasource.dart';

class TaskLocalDataSource implements ITaskLocalDataSource {
  final AppDatabase _db;

  const TaskLocalDataSource(this._db);

  @override
  Future<List<TaskEntity>> getTasksByLessonId(int lessonId) async {
    return await _db.managers.task
        .filter((f) => f.lessonId.id(lessonId))
        .orderBy((o) => o.orderIndex.asc())
        .get();
  }

  @override
  Future<TaskEntity?> getTaskById(int taskId) async {
    return await _db.managers.task
        .filter((f) => f.id(taskId))
        .getSingleOrNull();
  }

  @override
  Future<TaskEntity> insertTask(TaskCompanion entry) async {
    return await _db.into(_db.task).insertReturning(entry);
  }

  @override
  Future<void> updateTask(TaskCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Task id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.task)..where((t) => t.id.equals(id))).write(entry);
  }

  @override
  Future<List<TaskProgressEntity>> getUserTaskProgress(
    String userId,
    int lessonId,
  ) async {
    final tasks = await getTasksByLessonId(lessonId);
    final taskIds = tasks.map((t) => t.id).toList();

    if (taskIds.isEmpty) {
      return [];
    }

    return await _db.managers.taskProgress
        .filter((f) => f.userId.id(userId))
        .filter((f) => f.taskId.id.isIn(taskIds))
        .get();
  }

  @override
  Future<TaskProgressEntity?> getTaskProgress(String userId, int taskId) async {
    return await _db.managers.taskProgress
        .filter((f) => f.userId.id(userId))
        .filter((f) => f.taskId.id(taskId))
        .getSingleOrNull();
  }

  @override
  Future<TaskProgressEntity> insertTaskProgress(
    TaskProgressCompanion entry,
  ) async {
    return await _db.into(_db.taskProgress).insertReturning(entry);
  }

  @override
  Future<void> updateTaskProgress(TaskProgressCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('TaskProgress id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(
      _db.taskProgress,
    )..where((t) => t.id.equals(id))).write(entry);
  }

  @override
  Future<List<TaskOptionEntity>> getTaskOptions(int taskId) async {
    return await _db.managers.taskOption
        .filter((f) => f.taskId.id(taskId))
        .orderBy((o) => o.orderIndex.asc())
        .get();
  }

  @override
  Future<List<TaskTestCaseEntity>> getTaskTestCases(int taskId) async {
    return await _db.managers.taskTestCase
        .filter((f) => f.taskId.id(taskId))
        .orderBy((o) => o.orderIndex.asc())
        .get();
  }
}
