import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/task_entity_extension.dart';
import 'package:codium/data/entities/task_progress_entity_extension.dart';
import 'package:codium/domain/datasources/i_task_local_datasource.dart';
import 'package:codium/domain/models/task/create_task_progress_model.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/domain/models/task/task_progress_model.dart';
import 'package:codium/domain/models/task/task_result_model.dart';
import 'package:codium/domain/models/task/update_task_progress_model.dart';
import 'package:codium/domain/repositories/i_task_repository.dart';

class TaskRepository implements ITaskRepository {
  final ITaskLocalDataSource _localDataSource;

  const TaskRepository(this._localDataSource);

  @override
  Future<Result<List<TaskModel>>> getTasksByLessonId(int lessonId) async {
    try {
      final entities = await _localDataSource.getTasksByLessonId(lessonId);
      final tasks = entities.map((e) => e.toDomain()).toList();
      return Success(tasks);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<TaskModel>> getTaskById(int taskId) async {
    try {
      final entity = await _localDataSource.getTaskById(taskId);

      if (entity == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: '',
            canRetry: false,
          ),
        );
      }

      return Success(entity.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<TaskResultModel>> validateAnswer(
    int taskId,
    String answer,
    String userId,
  ) async {
    try {
      final taskEntity = await _localDataSource.getTaskById(taskId);

      if (taskEntity == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: '',
            canRetry: false,
          ),
        );
      }

      final task = taskEntity.toDomain();
      final isCorrect = _validateAnswerLogic(task, answer);

      return Success(
        TaskResultModel(
          isCorrect: isCorrect,
          xpEarned: task.xpValue,
          explanation: isCorrect ? null : task.fallbackExplanation,
          correctAnswer: isCorrect ? null : task.correctAnswer,
        ),
      );
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<void>> saveTaskProgress(
    CreateTaskProgressModel progress,
  ) async {
    try {
      await _localDataSource.insertTaskProgress(progress.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<void>> updateProgress(UpdateTaskProgressModel progress) async {
    try {
      await _localDataSource.updateTaskProgress(progress.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<TaskProgressModel?>> getTaskProgress(
    String userId,
    int taskId,
  ) async {
    try {
      final entity = await _localDataSource.getTaskProgress(userId, taskId);
      return Success(entity?.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<List<TaskProgressModel>>> getLessonProgress(
    String userId,
    int lessonId,
  ) async {
    try {
      final entities = await _localDataSource.getUserTaskProgress(
        userId,
        lessonId,
      );
      final progressList = entities.map((e) => e.toDomain()).toList();
      return Success(progressList);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  bool _validateAnswerLogic(TaskModel task, String answer) {
    // Теперь используем полиморфизм - каждый тип задачи знает как валидировать свой ответ
    return task.validateAnswer(answer);
  }
}
