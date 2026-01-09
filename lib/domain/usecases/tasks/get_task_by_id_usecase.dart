import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/task/task_model.dart';
import 'package:codium/domain/repositories/i_task_repository.dart';

class GetTaskByIdUseCase {
  final ITaskRepository _taskRepository;

  const GetTaskByIdUseCase(this._taskRepository);

  Future<Result<TaskModel>> call(int taskId) async {
    return await _taskRepository.getTaskById(taskId);
  }
}
