import 'package:codium/core/utils/result.dart';
import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
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
    required String userId,
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

    final hint = _resolveHint(hintResult, task.fallbackHint);
    if (hint == null) {
      final failure =
          hintResult.failureOrNull ??
          const AppFailure(
            code: AppErrorCode.apiGeneral,
            message: 'Hint unavailable',
          );
      return Failure(failure);
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

    return Success(hint);
  }

  String? _resolveHint(Result<String> hintResult, String? fallbackHint) {
    if (hintResult.isSuccess) {
      final hint = hintResult.dataOrNull?.trim();
      if (hint != null && hint.isNotEmpty) {
        return hint;
      }
    }

    final fallback = fallbackHint?.trim();
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }

    return null;
  }
}
