import 'package:praxis/domain/models/course/course_pricing.dart';
import 'package:praxis/domain/models/course/course_statistics.dart';
import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String author;
  final String category;
  final int priceInCoins;
  final int durationMinutes;
  final double rating;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final String tableOfContents;
  final CoursePricing pricing;
  final CourseStatistics statistics;
  final int totalTasks;
  final String? coverImage;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.category,
    required this.priceInCoins,
    required this.durationMinutes,
    required this.rating,
    this.thumbnailUrl,
    required this.createdAt,
    this.tableOfContents = '',
    required this.pricing,
    required this.statistics,
    this.totalTasks = 0,
    this.coverImage,
  });

  CourseModel copyWith({
    int? id,
    String? title,
    String? description,
    String? author,
    String? category,
    int? priceInCoins,
    int? durationMinutes,
    double? rating,
    String? thumbnailUrl,
    DateTime? createdAt,
    String? tableOfContents,
    CoursePricing? pricing,
    CourseStatistics? statistics,
    int? totalTasks,
    String? coverImage,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      category: category ?? this.category,
      priceInCoins: priceInCoins ?? this.priceInCoins,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rating: rating ?? this.rating,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      tableOfContents: tableOfContents ?? this.tableOfContents,
      pricing: pricing ?? this.pricing,
      statistics: statistics ?? this.statistics,
      totalTasks: totalTasks ?? this.totalTasks,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    author,
    category,
    priceInCoins,
    durationMinutes,
    rating,
    thumbnailUrl,
    createdAt,
    tableOfContents,
    pricing,
    statistics,
    totalTasks,
    coverImage,
  ];

  @override
  bool get stringify => true;
}
