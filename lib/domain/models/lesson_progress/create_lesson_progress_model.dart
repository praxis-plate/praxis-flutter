import 'package:equatable/equatable.dart';

class CreateLessonProgressModel extends Equatable {
  final int lessonId;
  final int userId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int timeSpentSeconds;

  const CreateLessonProgressModel({
    required this.lessonId,
    required this.userId,
    required this.isCompleted,
    this.completedAt,
    required this.timeSpentSeconds,
  });

  @override
  List<Object?> get props => [
    lessonId,
    userId,
    isCompleted,
    completedAt,
    timeSpentSeconds,
  ];

  @override
  bool get stringify => true;
}
