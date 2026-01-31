import 'package:praxis_client/praxis_client.dart';

class LessonRemoteDataSource {
  final Client _client;

  const LessonRemoteDataSource(this._client);

  Future<List<LessonDto>> getLessonsByModuleId(int moduleId) async {
    return await _client.lesson.getByModuleId(moduleId);
  }

  Future<List<LessonDto>> getLessonsByCourseId(int courseId) async {
    return await _client.lesson.getByCourseId(courseId);
  }

  Future<void> markComplete(int lessonId, {int timeSpentSeconds = 0}) async {
    return await _client.lesson.markComplete(
      lessonId,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}
