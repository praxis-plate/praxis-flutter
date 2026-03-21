import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/domain/models/lesson/create_lesson_model.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';
import 'package:praxis/domain/models/lesson/update_lesson_model.dart';
import 'package:drift/drift.dart';

extension LessonEntityExtension on LessonEntity {
  LessonModel toDomain() {
    return LessonModel(
      id: id,
      moduleId: moduleId,
      title: title,
      contentText: contentText,
      videoUrl: videoUrl,
      imageUrls: imageUrls,
      orderIndex: orderIndex,
      durationMinutes: durationMinutes,
      createdAt: createdAt,
    );
  }
}

extension CreateLessonModelExtension on CreateLessonModel {
  LessonCompanion toCompanion() {
    return LessonCompanion.insert(
      moduleId: moduleId,
      title: title,
      contentText: contentText,
      videoUrl: Value(videoUrl),
      imageUrls: Value(imageUrls),
      orderIndex: orderIndex,
      durationMinutes: durationMinutes,
      createdAt: DateTime.now(),
    );
  }
}

extension UpdateLessonModelExtension on UpdateLessonModel {
  LessonCompanion toCompanion() {
    return LessonCompanion(
      id: Value(id),
      title: title != null ? Value(title!) : const Value.absent(),
      contentText: contentText != null
          ? Value(contentText!)
          : const Value.absent(),
      videoUrl: videoUrl != null ? Value(videoUrl) : const Value.absent(),
      imageUrls: imageUrls != null ? Value(imageUrls) : const Value.absent(),
      orderIndex: orderIndex != null
          ? Value(orderIndex!)
          : const Value.absent(),
      durationMinutes: durationMinutes != null
          ? Value(durationMinutes!)
          : const Value.absent(),
    );
  }
}
