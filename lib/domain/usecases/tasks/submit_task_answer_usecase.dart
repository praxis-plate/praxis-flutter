import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:codium/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:codium/domain/models/task/create_task_progress_model.dart';
import 'package:codium/domain/models/task/task_result_model.dart';
import 'package:codium/domain/models/user_statistic/update_user_statistic_model.dart';
import 'package:codium/domain/repositories/i_coin_transaction_repository.dart';
import 'package:codium/domain/repositories/i_task_repository.dart';
import 'package:codium/domain/repositories/i_user_statistics_repository.dart';

class SubmitTaskAnswerUseCase {
  final ITaskRepository _taskRepository;
  final IUserStatisticsRepository _statisticsRepository;
  final ICoinTransactionRepository _coinRepository;

  const SubmitTaskAnswerUseCase(
    this._taskRepository,
    this._statisticsRepository,
    this._coinRepository,
  );

  Future<Result<TaskResultModel>> call({
    required int taskId,
    required String answer,
    required int userId,
    required int hintsUsed,
  }) async {
    final resultOrFailure = await _taskRepository.validateAnswer(
      taskId,
      answer,
      userId,
    );

    if (resultOrFailure.isFailure) {
      return resultOrFailure;
    }

    final result = resultOrFailure.dataOrNull!;

    int xpEarned = result.xpEarned;
    if (hintsUsed > 0) {
      xpEarned = (xpEarned * 0.5).round();
    }

    final progress = CreateTaskProgressModel(
      taskId: taskId,
      userId: userId,
      isCompleted: result.isCorrect,
      attempts: 1,
      hintsUsed: hintsUsed,
      xpEarned: xpEarned,
      userAnswer: answer,
      completedAt: result.isCorrect ? DateTime.now() : null,
      lastAttemptAt: DateTime.now(),
    );

    final saveResult = await _taskRepository.saveTaskProgress(progress);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    if (result.isCorrect) {
      final statisticsResult = await _statisticsRepository.getByUserId(userId);
      if (statisticsResult.isSuccess && statisticsResult.dataOrNull != null) {
        final statistics = statisticsResult.dataOrNull!;
        await _statisticsRepository.update(
          UpdateUserStatisticModel(
            id: statistics.id,
            experiencePoints: statistics.experiencePoints + xpEarned,
            lastActiveDate: DateTime.now(),
          ),
        );
      }

      await _coinRepository.create(
        CreateCoinTransactionModel(
          userId: userId,
          amount: 10,
          type: CoinTransactionType.taskCompletion,
          relatedEntityId: taskId.toString(),
        ),
      );
    }

    return Success(result.copyWith(xpEarned: xpEarned));
  }
}
