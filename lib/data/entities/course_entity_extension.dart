import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/course/course_model.dart';

extension CourseEntityExtension on CourseEntity {
  CourseModel toDomain() {
    return CourseModel(
      id: id,
      title: title,
      description: description,
      author: author,
      category: category,
      priceInCoins: priceInCoins,
      durationMinutes: durationMinutes,
      rating: rating,
      thumbnailUrl: thumbnailUrl,
      createdAt: createdAt,
    );
  }
}
