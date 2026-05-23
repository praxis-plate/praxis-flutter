import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_lesson_progress_repository.dart';

class CompleteLessonUseCase {
  final ILessonProgressRepository _lessonProgressRepository;

  const CompleteLessonUseCase({
    required ILessonProgressRepository lessonProgressRepository,
  }) : _lessonProgressRepository = lessonProgressRepository;

  Future<Result<void>> call({
    required String userId,
    required int lessonId,
  }) async {
    return _lessonProgressRepository.markComplete(lessonId, userId: userId);
  }
}
