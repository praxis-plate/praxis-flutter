import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/models/lesson_progress/update_lesson_progress_model.dart';

abstract interface class ILessonProgressRepository {
  Future<Result<List<LessonProgressModel>>> getCourseLessonProgress(
    String userId,
    int courseId,
  );
  Future<Result<LessonProgressModel?>> getLessonProgress(
    String userId,
    int lessonId,
  );
  Future<Result<void>> markLessonComplete(String userId, int lessonId);
  Future<Result<void>> updateLessonProgress(UpdateLessonProgressModel progress);
}
