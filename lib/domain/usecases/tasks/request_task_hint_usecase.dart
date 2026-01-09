import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/enums/programming_language.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/domain/models/task/update_task_progress_model.dart';
import 'package:codium/domain/repositories/i_task_repository.dart';
import 'package:codium/domain/services/i_ai_service.dart';

class RequestTaskHintUseCase {
  final ITaskRepository _taskRepository;
  final IAiService _aiService;

  const RequestTaskHintUseCase(this._taskRepository, this._aiService);

  Future<Result<String>> call({
    required int taskId,
    required int userId,
  }) async {
    final taskResult = await _taskRepository.getTaskById(taskId);

    if (taskResult.isFailure) {
      return Failure(taskResult.failureOrNull!);
    }

    final task = taskResult.dataOrNull!;

    final hintResult = await _aiService.generateHint(
      question: task.questionText,
      codeContext: task is CodeCompletionTaskModel ? task.codeTemplate : '',
      language: task is CodeCompletionTaskModel
          ? task.language
          : ProgrammingLanguage.dart,
      topic: task.topic,
    );

    if (hintResult.isFailure) {
      return Failure(hintResult.failureOrNull!);
    }

    final progressResult = await _taskRepository.getTaskProgress(
      userId,
      taskId,
    );
    if (progressResult.isSuccess && progressResult.dataOrNull != null) {
      final progress = progressResult.dataOrNull!;
      await _taskRepository.updateProgress(
        UpdateTaskProgressModel(
          id: progress.id,
          hintsUsed: progress.hintsUsed + 1,
        ),
      );
    }

    return hintResult;
  }
}
