import 'package:codium/data/database/app_database.dart';

abstract interface class ILessonLocalDataSource {
  Future<List<LessonEntity>> getLessonsByModuleId(int moduleId);
  Future<List<LessonEntity>> getLessonsByCourseId(int courseId);
  Future<LessonEntity?> getLessonById(int lessonId);
  Future<LessonEntity> insertLesson(LessonCompanion entry);
  Future<void> updateLesson(LessonCompanion entry);
}
