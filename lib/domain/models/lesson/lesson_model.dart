import 'package:equatable/equatable.dart';

class LessonModel extends Equatable {
  final int id;
  final int moduleId;
  final String title;
  final String contentText;
  final String? videoUrl;
  final String? imageUrls;
  final int orderIndex;
  final int durationMinutes;
  final DateTime createdAt;

  const LessonModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.contentText,
    this.videoUrl,
    this.imageUrls,
    required this.orderIndex,
    required this.durationMinutes,
    required this.createdAt,
  });

  LessonModel copyWith({
    int? id,
    int? moduleId,
    String? title,
    String? contentText,
    String? videoUrl,
    String? imageUrls,
    int? orderIndex,
    int? durationMinutes,
    DateTime? createdAt,
  }) {
    return LessonModel(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      contentText: contentText ?? this.contentText,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      orderIndex: orderIndex ?? this.orderIndex,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    moduleId,
    title,
    contentText,
    videoUrl,
    imageUrls,
    orderIndex,
    durationMinutes,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
