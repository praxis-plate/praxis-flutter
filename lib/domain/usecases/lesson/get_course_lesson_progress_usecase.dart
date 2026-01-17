import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';

class GetCourseLessonProgressUseCase {
  final ILessonProgressRepository _lessonProgressRepository;

  GetCourseLessonProgressUseCase(this._lessonProgressRepository);

  Future<Result<List<LessonProgressModel>>> call(
    int userId,
    int courseId,
  ) async {
    return _lessonProgressRepository.getCourseLessonProgress(userId, courseId);
  }
}
