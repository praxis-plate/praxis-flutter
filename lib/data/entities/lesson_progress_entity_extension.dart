import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/lesson_progress/create_lesson_progress_model.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:drift/drift.dart';

extension LessonProgressEntityExtension on LessonProgressEntity {
  LessonProgressModel toDomain() {
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

extension CreateLessonProgressModelExtension on CreateLessonProgressModel {
  LessonProgressCompanion toCompanion() {
    return LessonProgressCompanion.insert(
      lessonId: lessonId,
      userId: userId,
      isCompleted: Value(isCompleted),
      completedAt: Value(completedAt),
      timeSpentSeconds: Value(timeSpentSeconds),
    );
  }
}
