import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/enums/coin_transaction_type.dart';
import 'package:praxis/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:praxis/domain/models/task/create_task_progress_model.dart';
import 'package:praxis/domain/models/task/task_result_model.dart';
import 'package:praxis/domain/repositories/i_coin_transaction_repository.dart';
import 'package:praxis/domain/repositories/i_task_repository.dart';

class SubmitTaskAnswerUseCase {
  final ITaskRepository _taskRepository;
  final ICoinTransactionRepository _coinRepository;

  const SubmitTaskAnswerUseCase(this._taskRepository, this._coinRepository);

  Future<Result<TaskResultModel>> call({
    required int taskId,
    required String answer,
    required String userId,
    required int hintsUsed,
  }) async {
    final resultOrFailure = await _taskRepository.answer(
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
