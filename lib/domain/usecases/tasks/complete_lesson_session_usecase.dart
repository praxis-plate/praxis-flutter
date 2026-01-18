import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:codium/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:codium/domain/models/user_statistic/update_user_statistic_model.dart';
import 'package:codium/domain/repositories/i_coin_transaction_repository.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';
import 'package:codium/domain/repositories/i_user_statistics_repository.dart';

class CompleteLessonSessionUseCase {
  final ILessonProgressRepository _lessonProgressRepository;
  final IUserStatisticsRepository _userStatisticsRepository;
  final ICoinTransactionRepository _coinTransactionRepository;

  const CompleteLessonSessionUseCase(
    this._lessonProgressRepository,
    this._userStatisticsRepository,
    this._coinTransactionRepository,
  );

  Future<Result<void>> call({
    required String userId,
    required int lessonId,
    required int totalXpEarned,
    required int bonusXp,
  }) async {
    try {
      await _lessonProgressRepository.markLessonComplete(userId, lessonId);

      final totalXpWithBonus = totalXpEarned + bonusXp;

      final userStatResult = await _userStatisticsRepository.getByUserId(
        userId,
      );

      if (userStatResult.isSuccess && userStatResult.dataOrNull != null) {
        final currentStat = userStatResult.dataOrNull!;
        await _userStatisticsRepository.update(
          UpdateUserStatisticModel(
            id: currentStat.id,
            experiencePoints: (currentStat.experiencePoints + totalXpWithBonus)
                .toInt(),
          ),
        );
      }

      await _coinTransactionRepository.create(
        CreateCoinTransactionModel(
          userId: userId,
          amount: 50,
          type: CoinTransactionType.lessonCompletion,
          relatedEntityId: lessonId.toString(),
        ),
      );

      return const Success(null);
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
