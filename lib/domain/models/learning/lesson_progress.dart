import 'package:equatable/equatable.dart';

class LessonProgress extends Equatable {
  final String lessonId;
  final String courseId;
  final String userId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int timeSpentSeconds;

  const LessonProgress({
    required this.lessonId,
    required this.courseId,
    required this.userId,
    required this.isCompleted,
    this.completedAt,
    required this.timeSpentSeconds,
  });

  LessonProgress copyWith({
    String? lessonId,
    String? courseId,
    String? userId,
    bool? isCompleted,
    DateTime? completedAt,
    int? timeSpentSeconds,
  }) {
    return LessonProgress(
      lessonId: lessonId ?? this.lessonId,
      courseId: courseId ?? this.courseId,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
    );
  }

  @override
  List<Object?> get props => [
    lessonId,
    courseId,
    userId,
    isCompleted,
    completedAt,
    timeSpentSeconds,
  ];

  @override
  bool get stringify => true;
}
