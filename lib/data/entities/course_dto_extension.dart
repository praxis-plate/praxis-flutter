import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/course/course_pricing.dart';
import 'package:praxis/domain/models/course/course_review_model.dart';
import 'package:praxis/domain/models/course/course_statistics.dart';
import 'package:praxis/domain/models/user/money.dart';
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
      coverImage: coverImage,
      createdAt: createdAt,
      pricing: CoursePricing(price: Money.fromInt(priceInCoins)),
      statistics: CourseStatistics(
        totalEnrollments: 0,
        completionRate: 0,
        averageRating: rating,
      ),
      totalLessons: totalLessons,
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
      coverImage: Value(coverImage),
      createdAt: Value(createdAt),
    );
  }
}

extension CourseDetailDtoExtension on CourseDetailDto {
  CourseModel toDomain() {
    final reviewModels =
        (reviews ?? const [])
            .map(
              (review) => CourseReviewModel(
                id: review.id,
                courseId: review.courseId,
                authorName: review.authorName,
                isCurrentUserReview: review.isCurrentUserReview,
                rating: review.rating,
                comment: review.comment,
                createdAt: review.createdAt,
              ),
            )
            .toList()
          ..sort(
            (a, b) => b.isCurrentUserReview == a.isCurrentUserReview
                ? 0
                : (b.isCurrentUserReview ? 1 : -1),
          );

    return course.toDomain().copyWith(
      reviews: reviewModels,
      canSubmitReview: canSubmitReview ?? false,
      currentUserReview: currentUserReview == null
          ? null
          : CourseReviewModel(
              id: currentUserReview!.id,
              courseId: currentUserReview!.courseId,
              authorName: currentUserReview!.authorName,
              isCurrentUserReview: true,
              rating: currentUserReview!.rating,
              comment: currentUserReview!.comment,
              createdAt: currentUserReview!.createdAt,
            ),
    );
  }
}
