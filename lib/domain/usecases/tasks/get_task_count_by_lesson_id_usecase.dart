import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_task_repository.dart';

class GetTaskCountByLessonIdUseCase {
  final ITaskRepository _taskRepository;

  const GetTaskCountByLessonIdUseCase(this._taskRepository);

  Future<Result<int>> call(int lessonId) async {
    final result = await _taskRepository.getTasksByLessonId(lessonId);

    return result.when(
      success: (tasks) => Success(tasks.length),
      failure: (failure) => Failure(failure),
    );
  }
}
