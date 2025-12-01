import 'package:equatable/equatable.dart';

class CreateLessonModel extends Equatable {
  final int moduleId;
  final String title;
  final String contentText;
  final String? videoUrl;
  final String? imageUrls;
  final int orderIndex;
  final int durationMinutes;

  const CreateLessonModel({
    required this.moduleId,
    required this.title,
    required this.contentText,
    this.videoUrl,
    this.imageUrls,
    required this.orderIndex,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [
    moduleId,
    title,
    contentText,
    videoUrl,
    imageUrls,
    orderIndex,
    durationMinutes,
  ];

  @override
  bool get stringify => true;
}
