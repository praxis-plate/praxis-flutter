import 'package:praxis_client/praxis_client.dart';

class LessonProgressRemoteDataSource {
  final Client _client;

  const LessonProgressRemoteDataSource(this._client);

  Future<LessonCompletionResultDto> completeLessonSession({
    required int lessonId,
    required int timeSpentSeconds,
    required int bonusXp,
    required int correctTasks,
    required int totalTasks,
    required int totalXpEarned,
  }) async {
    final request = CompleteLessonSessionRequest(
      lessonId: lessonId,
      timeSpentSeconds: timeSpentSeconds,
      bonusXp: bonusXp,
      correctTasks: correctTasks,
      totalTasks: totalTasks,
      totalXpEarned: totalXpEarned,
    );

    return await _client.lesson.complete(request);
  }
}
