import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_task_repository.dart';

class GetCompletedTaskCountByLessonIdUseCase {
  final ITaskRepository _taskRepository;

  const GetCompletedTaskCountByLessonIdUseCase(this._taskRepository);

  Future<Result<int>> call(String userId, int lessonId) async {
    return await _taskRepository.getCompletedTaskCount(userId, lessonId);
  }
}
