import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/datasources/local/task_local_datasource.dart';
import 'package:codium/data/datasources/remote/task_remote_datasource.dart';
import 'package:codium/data/entities/task_dto_extension.dart';
import 'package:codium/data/entities/task_progress_entity_extension.dart';
import 'package:codium/domain/models/task/create_task_progress_model.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/domain/models/task/task_progress_model.dart';
import 'package:codium/domain/models/task/task_result_model.dart';
import 'package:codium/domain/models/task/update_task_progress_model.dart';
import 'package:codium/domain/repositories/i_task_repository.dart';

class TaskRepository implements ITaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;

  const TaskRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<List<TaskModel>>> getTasksByLessonId(int lessonId) async {
    try {
      final taskDtos = await _remoteDataSource.getTasksByLessonId(lessonId);
      final tasks = taskDtos.map((dto) => dto.toDomain()).toList();
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
      final taskDto = await _remoteDataSource.getTaskById(taskId);
      return Success(taskDto.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<TaskResultModel>> answer(
    int taskId,
    String answer,
    String userId,
  ) async {
    try {
      final resultMap = await _remoteDataSource.submitAnswer(
        taskId,
        answer,
        userId,
      );
      // Convert Map<String, dynamic> to TaskResultModel
      final result = TaskResultModel(
        isCorrect: resultMap['isCorrect'] as bool,
        xpEarned: resultMap['xpEarned'] as int,
        explanation: resultMap['explanation'] as String?,
        correctAnswer: resultMap['correctAnswer'] as String?,
      );
      return Success(result);
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
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<TaskProgressModel?>> getTaskProgress(
    String userId,
    int taskId,
  ) async {
    try {
      final progressEntity = await _localDataSource.getTaskProgress(
        userId,
        taskId,
      );
      return Success(progressEntity?.toDomain());
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> updateProgress(UpdateTaskProgressModel progress) async {
    try {
      await _localDataSource.updateTaskProgress(progress.toCompanion());
      return const Success(null);
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
