import 'package:praxis/domain/models/lesson/lesson_completion_result_model.dart';
import 'package:praxis_client/praxis_client.dart';

import 'achievement_dto_extension.dart';

extension LessonCompletionResultDtoExtension on LessonCompletionResultDto {
  LessonCompletionResultModel toDomain() {
    return LessonCompletionResultModel(
      lessonId: lessonId,
      totalXpEarned: totalXpEarned,
      bonusXp: bonusXp,
      lessonCompletionXp: lessonCompletionXp,
      totalXpWithBonus: totalXpWithBonus,
      timeSpentSeconds: timeSpentSeconds,
      totalTasks: totalTasks,
      correctTasks: correctTasks,
      accuracyPercentage: accuracyPercentage,
      coinsAwarded: coinsAwarded,
      experiencePoints: experiencePoints,
      currentStreak: currentStreak,
      unlockedAchievements: unlockedAchievements
          .map((item) => item.toDomain())
          .toList(),
    );
  }
}
