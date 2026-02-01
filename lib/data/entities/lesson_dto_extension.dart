import 'package:codium/domain/models/lesson/lesson_model.dart';
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
