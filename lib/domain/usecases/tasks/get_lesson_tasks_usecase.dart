import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/task/task_model.dart';
import 'package:praxis/domain/repositories/i_task_repository.dart';

class GetLessonTasksUseCase {
  final ITaskRepository _taskRepository;

  const GetLessonTasksUseCase(this._taskRepository);

  Future<Result<List<TaskModel>>> call(int lessonId) async {
    return await _taskRepository.getTasksByLessonId(lessonId);
  }
}
