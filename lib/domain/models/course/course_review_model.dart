import 'package:equatable/equatable.dart';

class CourseReviewModel extends Equatable {
  final int id;
  final int courseId;
  final String authorName;
  final bool isCurrentUserReview;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const CourseReviewModel({
    required this.id,
    required this.courseId,
    required this.authorName,
    required this.isCurrentUserReview,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    courseId,
    authorName,
    isCurrentUserReview,
    rating,
    comment,
    createdAt,
  ];
}
