import 'package:praxis/data/database/app_database.dart';

class LessonLocalDataSource {
  final AppDatabase _db;

  const LessonLocalDataSource(this._db);

  Future<List<LessonEntity>> getLessonsByModuleId(int moduleId) async {
    return await _db.managers.lesson
        .filter((f) => f.moduleId.id(moduleId))
        .get();
  }

  Future<List<LessonEntity>> getLessonsByCourseId(int courseId) async {
    return await _db.managers.lesson
        .filter((f) => f.moduleId.courseId.id(courseId))
        .get();
  }

  Future<LessonEntity?> getLessonById(int lessonId) async {
    return await _db.managers.lesson
        .filter((f) => f.id(lessonId))
        .getSingleOrNull();
  }

  Future<LessonEntity> insertLesson(LessonCompanion entry) async {
    return await _db.into(_db.lesson).insertReturning(entry);
  }

  Future<void> updateLesson(LessonCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Lesson id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.lesson)..where((t) => t.id.equals(id))).write(entry);
  }
}
