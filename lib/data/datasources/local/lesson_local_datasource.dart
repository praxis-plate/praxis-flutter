import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_lesson_local_datasource.dart';

class LessonLocalDataSource implements ILessonLocalDataSource {
  final AppDatabase _db;

  const LessonLocalDataSource(this._db);

  @override
  Future<List<LessonEntity>> getLessonsByModuleId(int moduleId) async {
    return await _db.managers.lesson
        .filter((f) => f.moduleId.id(moduleId))
        .get();
  }

  @override
  Future<List<LessonEntity>> getLessonsByCourseId(int courseId) async {
    return await _db.managers.lesson
        .filter((f) => f.moduleId.courseId.id(courseId))
        .get();
  }

  @override
  Future<LessonEntity?> getLessonById(int lessonId) async {
    return await _db.managers.lesson
        .filter((f) => f.id(lessonId))
        .getSingleOrNull();
  }

  @override
  Future<LessonEntity> insertLesson(LessonCompanion entry) async {
    return await _db.into(_db.lesson).insertReturning(entry);
  }

  @override
  Future<void> updateLesson(LessonCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Lesson id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.lesson)..where((t) => t.id.equals(id))).write(entry);
  }
}
