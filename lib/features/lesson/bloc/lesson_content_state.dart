part of 'lesson_content_bloc.dart';

abstract class LessonContentState extends Equatable {
  const LessonContentState();

  @override
  List<Object?> get props => [];
}

class LessonContentInitial extends LessonContentState {
  const LessonContentInitial();
}

class LessonContentLoading extends LessonContentState {
  const LessonContentLoading();
}

class LessonContentLoaded extends LessonContentState {
  final CourseTask lesson;
  final bool isCompleted;

  const LessonContentLoaded({required this.lesson, required this.isCompleted});

  @override
  List<Object?> get props => [lesson, isCompleted];
}

class LessonContentCompleting extends LessonContentState {
  const LessonContentCompleting();
}

class LessonContentCompleted extends LessonContentState {
  final int coinsEarned;
  final List<AchievementModel> achievements;

  const LessonContentCompleted({
    required this.coinsEarned,
    required this.achievements,
  });

  @override
  List<Object?> get props => [coinsEarned, achievements];
}

class LessonContentError extends LessonContentState {
  final String message;

  const LessonContentError({required this.message});

  @override
  List<Object?> get props => [message];
}
