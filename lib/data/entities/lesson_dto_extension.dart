import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';
import 'package:drift/drift.dart';
import 'package:praxis_client/praxis_client.dart';

extension LessonDtoExtension on LessonDto {
  LessonModel toDomain() {
    return LessonModel(
      id: id,
      moduleId: moduleId,
      title: title,
      contentText: contentText,
      videoUrl: videoUrl,
      imageUrls: imageUrls ?? '',
      orderIndex: orderIndex,
      durationMinutes: durationMinutes,
      createdAt: createdAt,
    );
  }
}

extension LessonDtoCompanionExtension on LessonDto {
  LessonCompanion toCompanion() {
    return LessonCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      title: Value(title),
      contentText: Value(contentText),
      videoUrl: Value(videoUrl),
      imageUrls: Value(imageUrls),
      orderIndex: Value(orderIndex),
      durationMinutes: Value(durationMinutes),
      createdAt: Value(createdAt),
    );
  }
}
