import 'package:equatable/equatable.dart';

class UpdateLessonModel extends Equatable {
  final int id;
  final String? title;
  final String? contentText;
  final String? videoUrl;
  final String? imageUrls;
  final int? orderIndex;
  final int? durationMinutes;

  const UpdateLessonModel({
    required this.id,
    this.title,
    this.contentText,
    this.videoUrl,
    this.imageUrls,
    this.orderIndex,
    this.durationMinutes,
  });

  @override
  List<Object?> get props => [
    id,
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
