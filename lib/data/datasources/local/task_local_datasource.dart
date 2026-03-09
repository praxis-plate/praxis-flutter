import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class TaskLocalDataSource {
  final AppDatabase _db;

  const TaskLocalDataSource(this._db);

  Future<List<TaskEntity>> getTasksByLessonId(int lessonId) async {
    return await _db.managers.task
        .filter((f) => f.lessonId.id(lessonId))
        .orderBy((o) => o.orderIndex.asc())
        .get();
  }

  Future<TaskEntity?> getTaskById(int taskId) async {
    return await _db.managers.task
        .filter((f) => f.id(taskId))
        .getSingleOrNull();
  }

  Future<TaskEntity> insertTask(TaskCompanion entry) async {
    return await _db.into(_db.task).insertReturning(entry);
  }

  Future<void> updateTask(TaskCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Task id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.task)..where((t) => t.id.equals(id))).write(entry);
  }

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

  Future<TaskProgressEntity?> getTaskProgress(String userId, int taskId) async {
    final resolvedUserId = await _resolveUserId(userId);
    return await _db.managers.taskProgress
        .filter((f) => f.userId.id(resolvedUserId))
        .filter((f) => f.taskId.id(taskId))
        .getSingleOrNull();
  }

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

    throw StateError(
      'Cannot resolve local task progress for unknown user: $userId',
    );
  }

  Future<void> updateTaskProgress(TaskProgressCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('TaskProgress id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(
      _db.taskProgress,
    )..where((t) => t.id.equals(id))).write(entry);
  }

  Future<List<TaskOptionEntity>> getTaskOptions(int taskId) async {
    return await _db.managers.taskOption
        .filter((f) => f.taskId.id(taskId))
        .orderBy((o) => o.orderIndex.asc())
        .get();
  }

  Future<List<TaskTestCaseEntity>> getTaskTestCases(int taskId) async {
    return await _db.managers.taskTestCase
        .filter((f) => f.taskId.id(taskId))
        .orderBy((o) => o.orderIndex.asc())
        .get();
  }
}
