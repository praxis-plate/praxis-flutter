import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/task/create_task_progress_model.dart';
import 'package:codium/domain/models/task/task_model.dart';
import 'package:codium/domain/models/task/task_progress_model.dart';
import 'package:codium/domain/models/task/task_result_model.dart';
import 'package:codium/domain/models/task/update_task_progress_model.dart';

abstract interface class ITaskRepository {
  Future<Result<List<TaskModel>>> getTasksByLessonId(int lessonId);

  Future<Result<TaskModel>> getTaskById(int taskId);

  Future<Result<TaskResultModel>> validateAnswer(
    int taskId,
    String answer,
    int userId,
  );

  Future<Result<void>> saveTaskProgress(CreateTaskProgressModel progress);

  Future<Result<void>> updateProgress(UpdateTaskProgressModel progress);

  Future<Result<TaskProgressModel?>> getTaskProgress(int userId, int taskId);

  Future<Result<List<TaskProgressModel>>> getLessonProgress(
    int userId,
    int lessonId,
  );
}
