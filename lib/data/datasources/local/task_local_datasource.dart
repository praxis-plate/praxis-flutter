import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_task_local_datasource.dart';
import 'package:drift/drift.dart';

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
    final resolvedUserId = await _resolveUserId(userId);
    final tasks = await getTasksByLessonId(lessonId);
    final taskIds = tasks.map((t) => t.id).toList();

    if (taskIds.isEmpty) {
      return [];
    }

    return await _db.managers.taskProgress
        .filter((f) => f.userId.id(resolvedUserId))
        .filter((f) => f.taskId.id.isIn(taskIds))
        .get();
  }

  @override
  Future<TaskProgressEntity?> getTaskProgress(String userId, int taskId) async {
    final resolvedUserId = await _resolveUserId(userId);
    return await _db.managers.taskProgress
        .filter((f) => f.userId.id(resolvedUserId))
        .filter((f) => f.taskId.id(taskId))
        .getSingleOrNull();
  }

  @override
  Future<TaskProgressEntity> insertTaskProgress(
    TaskProgressCompanion entry,
  ) async {
    if (!entry.userId.present) {
      throw ArgumentError('TaskProgress userId must be present for insert');
    }

    final resolvedUserId = await _resolveUserId(entry.userId.value);
    final insertEntry = resolvedUserId == entry.userId.value
        ? entry
        : entry.copyWith(userId: Value(resolvedUserId));

    return await _db.into(_db.taskProgress).insertReturning(insertEntry);
  }

  Future<String> _resolveUserId(String userId) async {
    final existingUser = await _db.managers.user
        .filter((f) => f.id(userId))
        .getSingleOrNull();

    if (existingUser != null) {
      return userId;
    }

    // TODO: Remove after testing
    final fallbackUser = await (_db.select(
      _db.user,
    )..limit(1)).getSingleOrNull();

    return fallbackUser?.id ?? userId;
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
