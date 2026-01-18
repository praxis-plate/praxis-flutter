import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CompleteLessonUseCase {
  final ILessonProgressRepository _lessonProgressRepository;

  const CompleteLessonUseCase({
    required ILessonProgressRepository lessonProgressRepository,
  }) : _lessonProgressRepository = lessonProgressRepository;

  Future<Result<void>> call({
    required String userId,
    required int lessonId,
  }) async {
    final result = await _lessonProgressRepository.markLessonComplete(
      userId,
      lessonId,
    );

    result.when(
      success: (_) {
        GetIt.I<Talker>().info('Lesson completed: $lessonId for user $userId');
      },
      failure: (failure) {
        GetIt.I<Talker>().error(
          'Failed to complete lesson: ${failure.message}',
        );
      },
    );

    return result;
  }
}
