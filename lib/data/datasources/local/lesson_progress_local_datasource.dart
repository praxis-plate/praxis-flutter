import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_lesson_progress_local_datasource.dart';

class LessonProgressLocalDataSource implements ILessonProgressLocalDataSource {
  final AppDatabase _db;

  const LessonProgressLocalDataSource(this._db);

  @override
  Future<List<LessonProgressEntity>> getCourseLessonProgress(
    String userId,
    int courseId,
  ) async {
    return await _db.managers.lessonProgress
        .filter((f) => f.userId.id(userId))
        .filter((f) => f.lessonId.moduleId.courseId.id(courseId))
        .get();
  }

  @override
  Future<LessonProgressEntity?> getLessonProgress(
    String userId,
    int lessonId,
  ) async {
    return await _db.managers.lessonProgress
        .filter((f) => f.userId.id(userId))
        .filter((f) => f.lessonId.id(lessonId))
        .getSingleOrNull();
  }

  @override
  Future<LessonProgressEntity> insertLessonProgress(
    LessonProgressCompanion entry,
  ) async {
    return _db.into(_db.lessonProgress).insertReturning(entry);
  }

  @override
  Future<void> updateLessonProgress(LessonProgressCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('LessonProgress id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(
      _db.lessonProgress,
    )..where((t) => t.id.equals(id))).write(entry);
  }
}
