import 'package:praxis_client/praxis_client.dart';

class TaskRemoteDataSource {
  final Client _client;

  const TaskRemoteDataSource(this._client);

  Future<List<TaskDto>> getTasksByLessonId(int lessonId) async {
    return await _client.task.getByLessonId(lessonId);
  }

  Future<TaskDto> getTaskById(int taskId) async {
    return await _client.task.getById(taskId);
  }

  Future<TaskAnswerResultDto> submitAnswer(
    int taskId,
    String answer,
    String userId,
  ) async {
    return await _client.task.answer(taskId, answer);
  }
}
