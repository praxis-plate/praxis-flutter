import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/course/course_pricing.dart';
import 'package:praxis/domain/models/course/course_statistics.dart';
import 'package:praxis/domain/models/user/money.dart';

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
      tableOfContents: '',
      pricing: CoursePricing(price: Money(amount: priceInCoins)),
      statistics: CourseStatistics(
        averageRating: rating,
        totalEnrollments: 0,
        completionRate: 0,
      ),
      totalTasks: 0,
      coverImage: thumbnailUrl,
    );
  }
}
