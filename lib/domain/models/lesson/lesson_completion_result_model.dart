import 'package:equatable/equatable.dart';
import 'package:praxis/domain/models/achievement/achievement_data_model.dart';

class LessonCompletionResultModel extends Equatable {
  final int lessonId;
  final int totalXpEarned;
  final int bonusXp;
  final int lessonCompletionXp;
  final int totalXpWithBonus;
  final int timeSpentSeconds;
  final int totalTasks;
  final int correctTasks;
  final double accuracyPercentage;
  final int coinsAwarded;
  final int experiencePoints;
  final int currentStreak;
  final List<AchievementModel> unlockedAchievements;

  const LessonCompletionResultModel({
    required this.lessonId,
    required this.totalXpEarned,
    required this.bonusXp,
    required this.lessonCompletionXp,
    required this.totalXpWithBonus,
    required this.timeSpentSeconds,
    required this.totalTasks,
    required this.correctTasks,
    required this.accuracyPercentage,
    required this.coinsAwarded,
    required this.experiencePoints,
    required this.currentStreak,
    required this.unlockedAchievements,
  });

  @override
  List<Object?> get props => [
    lessonId,
    totalXpEarned,
    bonusXp,
    lessonCompletionXp,
    totalXpWithBonus,
    timeSpentSeconds,
    totalTasks,
    correctTasks,
    accuracyPercentage,
    coinsAwarded,
    experiencePoints,
    currentStreak,
    unlockedAchievements,
  ];

  @override
  bool get stringify => true;
}
