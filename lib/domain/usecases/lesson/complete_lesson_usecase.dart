import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';

class CompleteLessonUseCase {
  final ILessonProgressRepository _lessonProgressRepository;

  const CompleteLessonUseCase({
    required ILessonProgressRepository lessonProgressRepository,
  }) : _lessonProgressRepository = lessonProgressRepository;

  Future<Result<void>> call({
    required int userId,
    required int lessonId,
  }) async {
    final result = await _lessonProgressRepository.markLessonComplete(
      userId,
      lessonId,
    );

    return result;
  }
}
