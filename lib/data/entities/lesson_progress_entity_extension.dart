import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/domain/models/lesson_progress/create_lesson_progress_model.dart';
import 'package:praxis/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:praxis/domain/models/lesson_progress/update_lesson_progress_model.dart';
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

extension UpdateLessonProgressModelExtension on UpdateLessonProgressModel {
  LessonProgressCompanion toCompanion() {
    return LessonProgressCompanion(
      id: Value(id),
      isCompleted: isCompleted != null ? Value(isCompleted!) : const Value.absent(),
      completedAt: completedAt != null ? Value(completedAt!) : const Value.absent(),
      timeSpentSeconds: timeSpentSeconds != null
          ? Value(timeSpentSeconds!)
          : const Value.absent(),
    );
  }
}
