import 'package:codium/domain/models/course/course_pricing.dart';
import 'package:codium/domain/models/course/course_statistics.dart';
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
  final CoursePricing pricing;
  final CourseStatistics statistics;
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
    required this.pricing,
    required this.statistics,
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
    CoursePricing? pricing,
    CourseStatistics? statistics,
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
      pricing: pricing ?? this.pricing,
      statistics: statistics ?? this.statistics,
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
    pricing,
    statistics,
    coverImage,
  ];

  @override
  bool get stringify => true;
}
