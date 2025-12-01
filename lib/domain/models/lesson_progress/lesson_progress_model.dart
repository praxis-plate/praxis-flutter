import 'package:equatable/equatable.dart';

class LessonProgressModel extends Equatable {
  final int id;
  final int lessonId;
  final int userId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int timeSpentSeconds;

  const LessonProgressModel({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.isCompleted,
    this.completedAt,
    required this.timeSpentSeconds,
  });

  LessonProgressModel copyWith({
    int? id,
    int? lessonId,
    int? userId,
    bool? isCompleted,
    DateTime? completedAt,
    int? timeSpentSeconds,
  }) {
    return LessonProgressModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    lessonId,
    userId,
    isCompleted,
    completedAt,
    timeSpentSeconds,
  ];

  @override
  bool get stringify => true;
}
