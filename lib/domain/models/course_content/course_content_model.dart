import 'package:codium/domain/models/course/course_model.dart';

class CourseContentModel extends CourseModel {
  final String tableOfContents;
  final int lessonsCount;

  const CourseContentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.author,
    required super.category,
    required super.priceInCoins,
    required super.durationMinutes,
    required super.rating,
    required super.createdAt,
    required super.pricing,
    required super.statistics,
    super.thumbnailUrl,
    super.coverImage,
    this.tableOfContents = '',
    this.lessonsCount = 0,
  });

  factory CourseContentModel.fromCourse(
    CourseModel course, {
    required String tableOfContents,
    required int totalLessons,
  }) {
    return CourseContentModel(
      id: course.id,
      title: course.title,
      description: course.description,
      author: course.author,
      category: course.category,
      priceInCoins: course.priceInCoins,
      durationMinutes: course.durationMinutes,
      rating: course.rating,
      thumbnailUrl: course.thumbnailUrl,
      createdAt: course.createdAt,
      pricing: course.pricing,
      statistics: course.statistics,
      coverImage: course.coverImage,
      tableOfContents: tableOfContents,
      lessonsCount: totalLessons,
    );
  }

  @override
  List<Object?> get props => [...super.props, tableOfContents, lessonsCount];
}
