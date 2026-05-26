import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/lesson/lesson_completion_result_model.dart';
import 'package:praxis/domain/repositories/i_lesson_progress_repository.dart';

class CompleteLessonSessionUseCase {
  final ILessonProgressRepository _lessonProgressRepository;

  const CompleteLessonSessionUseCase(this._lessonProgressRepository);

  Future<Result<LessonCompletionResultModel>> call({
    required String userId,
    required int lessonId,
    required int timeSpentSeconds,
    required int totalXpEarned,
    required int bonusXp,
    required int correctTasks,
    required int totalTasks,
  }) async {
    try {
      return await _lessonProgressRepository.completeLessonSession(
        userId: userId,
        lessonId: lessonId,
        timeSpentSeconds: timeSpentSeconds,
        bonusXp: bonusXp,
        correctTasks: correctTasks,
        totalTasks: totalTasks,
        totalXpEarned: totalXpEarned,
      );
    } catch (e) {
      return Failure(
        AppFailure(
          code: AppErrorCode.unknown,
          message: 'Failed to complete lesson session: ${e.toString()}',
          canRetry: true,
        ),
      );
    }
  }
}
