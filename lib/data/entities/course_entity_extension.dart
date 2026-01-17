import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/course/course_pricing.dart';
import 'package:codium/domain/models/course/course_statistics.dart';
import 'package:codium/domain/models/user/money.dart';

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
      pricing: CoursePricing(price: Money(amount: priceInCoins)),
      statistics: CourseStatistics(
        averageRating: rating,
        totalEnrollments: 0,
        completionRate: 0,
      ),
      coverImage: thumbnailUrl,
    );
  }
}
