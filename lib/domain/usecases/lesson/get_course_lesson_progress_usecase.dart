import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';

class GetCourseLessonProgressUseCase {
  final ILessonProgressRepository _lessonProgressRepository;

  const GetCourseLessonProgressUseCase({
    required ILessonProgressRepository lessonProgressRepository,
  }) : _lessonProgressRepository = lessonProgressRepository;

  Future<Result<List<LessonProgressModel>>> call({
    required String userId,
    required int courseId,
  }) {
    return _lessonProgressRepository.getCourseLessonProgress(userId, courseId);
  }
}
