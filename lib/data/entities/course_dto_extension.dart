import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/course/course_pricing.dart';
import 'package:codium/domain/models/course/course_statistics.dart';
import 'package:codium/domain/models/user/money.dart';
import 'package:drift/drift.dart';
import 'package:praxis_client/praxis_client.dart';

extension CourseDtoExtension on CourseDto {
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
      pricing: CoursePricing(price: Money.fromInt(priceInCoins)),
      statistics: CourseStatistics(
        totalEnrollments: 0,
        completionRate: 0,
        averageRating: rating,
      ),
      totalTasks: totalTasks,
    );
  }
}

extension CourseDtoCompanionExtension on CourseDto {
  CourseCompanion toCompanion() {
    return CourseCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      author: Value(author),
      category: Value(category),
      priceInCoins: Value(priceInCoins),
      durationMinutes: Value(durationMinutes),
      rating: Value(rating),
      thumbnailUrl: Value(thumbnailUrl),
      createdAt: Value(createdAt),
    );
  }
}

extension CourseDetailDtoExtension on CourseDetailDto {
  CourseModel toDomain() {
    return course.toDomain();
  }
}
