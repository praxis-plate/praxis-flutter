import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/task/task_model.dart';
import 'package:praxis/domain/repositories/i_task_repository.dart';

class GetTaskByIdUseCase {
  final ITaskRepository _taskRepository;

  const GetTaskByIdUseCase(this._taskRepository);

  Future<Result<TaskModel>> call(int taskId) async {
    return await _taskRepository.getTaskById(taskId);
  }
}
