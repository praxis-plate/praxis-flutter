import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/entities/course_dto_extension.dart';
import 'package:praxis/data/entities/lesson_dto_extension.dart';
import 'package:praxis/data/entities/lesson_progress_entity_extension.dart';
import 'package:praxis/data/entities/module_dto_extension.dart';
import 'package:praxis/data/entities/task_dto_extension.dart';
import 'package:praxis/data/entities/task_progress_entity_extension.dart';
import 'package:praxis_client/praxis_client.dart';

class CourseLocalDataSource {
  final AppDatabase _db;

  const CourseLocalDataSource(this._db);

  Future<List<CourseEntity>> getAllCourses() async {
    return await _db.managers.course.get();
  }

  Future<CourseEntity?> getCourseById(int courseId) async {
    return await _db.managers.course
        .filter((f) => f.id(courseId))
        .getSingleOrNull();
  }

  Future<CourseEntity> insertCourse(CourseCompanion entry) async {
    return await _db.into(_db.course).insertReturning(entry);
  }

  Future<void> upsertCourse(CourseCompanion entry) async {
    await _db.into(_db.course).insertOnConflictUpdate(entry);
  }

  Future<void> replaceCourseDetailSnapshot(CourseDetailDto detail) async {
    final courseId = detail.course.id;
    final lessonIds = detail.lessons.map((lesson) => lesson.id).toSet();
    final taskIds = detail.tasks.map((task) => task.id).toSet();

    await _db.transaction(() async {
      final lessonProgress = await _getRestorableLessonProgress(lessonIds);
      final taskProgress = await _getRestorableTaskProgress(taskIds);

      await (_db.delete(
        _db.module,
      )..where((module) => module.courseId.equals(courseId))).go();

      await _db
          .into(_db.course)
          .insertOnConflictUpdate(detail.course.toCompanion());

      await _db.batch((batch) {
        if (detail.modules.isNotEmpty) {
          batch.insertAllOnConflictUpdate(
            _db.module,
            detail.modules.map((module) => module.toCompanion()).toList(),
          );
        }

        if (detail.lessons.isNotEmpty) {
          batch.insertAllOnConflictUpdate(
            _db.lesson,
            detail.lessons.map((lesson) => lesson.toCompanion()).toList(),
          );
        }

        if (detail.tasks.isNotEmpty) {
          batch.insertAllOnConflictUpdate(
            _db.task,
            detail.tasks.map((task) => task.toCompanion()).toList(),
          );
        }

        if (lessonProgress.isNotEmpty) {
          batch.insertAll(
            _db.lessonProgress,
            lessonProgress
                .map((progress) => progress.toInsertCompanion())
                .toList(),
          );
        }

        if (taskProgress.isNotEmpty) {
          batch.insertAll(
            _db.taskProgress,
            taskProgress
                .map((progress) => progress.toInsertCompanion())
                .toList(),
          );
        }
      });
    });
  }

  Future<void> upsertCourses(List<CourseCompanion> entries) async {
    if (entries.isEmpty) {
      return;
    }

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.course, entries);
    });
  }

  Future<void> updateCourse(CourseCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Course id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.course)..where((t) => t.id.equals(id))).write(entry);
  }

  Future<List<CourseEntity>> getEnrolledCourses(String userId) async {
    final userCourses = await _db.managers.userCourse
        .filter((f) => f.userId.id(userId))
        .get();

    final courseIds = userCourses.map((e) => e.courseId).toList();

    if (courseIds.isEmpty) {
      return [];
    }

    return await _db.managers.course.filter((f) => f.id.isIn(courseIds)).get();
  }

  Future<void> enrollUserInCourse(UserCourseCompanion entry) async {
    await _db.into(_db.userCourse).insert(entry);
  }

  Future<bool> isUserEnrolled(String userId, int courseId) async {
    final enrollments = await _db.managers.userCourse
        .filter((f) => f.userId.id(userId))
        .filter((f) => f.courseId.id(courseId))
        .get();

    return enrollments.isNotEmpty;
  }

  Future<List<LessonProgressEntity>> _getRestorableLessonProgress(
    Set<int> lessonIds,
  ) async {
    if (lessonIds.isEmpty) {
      return [];
    }

    return (_db.select(
      _db.lessonProgress,
    )..where((progress) => progress.lessonId.isIn(lessonIds))).get();
  }

  Future<List<TaskProgressEntity>> _getRestorableTaskProgress(
    Set<int> taskIds,
  ) async {
    if (taskIds.isEmpty) {
      return [];
    }

    return (_db.select(
      _db.taskProgress,
    )..where((progress) => progress.taskId.isIn(taskIds))).get();
  }
}
