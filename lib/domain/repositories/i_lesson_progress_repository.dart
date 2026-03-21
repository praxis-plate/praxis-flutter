import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/lesson_progress/lesson_progress_model.dart';

abstract interface class ILessonProgressRepository {
  Future<Result<void>> markComplete(
    int lessonId, {
    required String userId,
    int timeSpentSeconds = 0,
  });

  Future<Result<List<LessonProgressModel>>> getCourseLessonProgress(
    String userId,
    int courseId,
  );
}
