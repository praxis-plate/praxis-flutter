part of 'lesson_content_bloc.dart';

abstract class LessonContentEvent extends Equatable {
  const LessonContentEvent();

  @override
  List<Object?> get props => [];
}

class LoadLessonContent extends LessonContentEvent {
  final String lessonId;
  final String userId;
  final String courseId;

  const LoadLessonContent({
    required this.lessonId,
    required this.userId,
    required this.courseId,
  });

  @override
  List<Object?> get props => [lessonId, userId, courseId];
}

class CompleteLesson extends LessonContentEvent {
  final String userId;
  final String lessonId;
  final String courseId;

  const CompleteLesson({
    required this.userId,
    required this.lessonId,
    required this.courseId,
  });

  @override
  List<Object?> get props => [userId, lessonId, courseId];
}
