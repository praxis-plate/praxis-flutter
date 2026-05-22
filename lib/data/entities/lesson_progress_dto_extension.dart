import 'package:praxis/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:praxis_client/praxis_client.dart';

extension LessonProgressDtoExtension on LessonProgressDto {
  LessonProgressModel toDomain(String userId) {
    return LessonProgressModel(
      id: id,
      lessonId: lessonId,
      userId: userId,
      isCompleted: isCompleted,
      completedAt: completedAt,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}
