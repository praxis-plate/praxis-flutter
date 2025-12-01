import 'package:codium/data/database/app_database.dart';

abstract interface class ILessonProgressLocalDataSource {
  Future<List<LessonProgressEntity>> getCourseLessonProgress(
    int userId,
    int courseId,
  );

  Future<LessonProgressEntity?> getLessonProgress(int userId, int lessonId);

  Future<LessonProgressEntity> insertLessonProgress(
    LessonProgressCompanion entry,
  );

  Future<void> updateLessonProgress(LessonProgressCompanion entry);
}
