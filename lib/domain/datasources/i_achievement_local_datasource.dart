import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/entities/unlocked_achievement_entity.dart';

abstract interface class IAchievementLocalDataSource {
  Future<List<AchievementEntity>> getAllAchievements();

  Future<AchievementEntity?> getAchievementById(int id);

  Future<List<UnlockedAchievementEntity>> getUserAchievements(String userId);

  Future<void> insertUserAchievement(
    String userId,
    int achievementId,
    DateTime unlockedAt,
  );

  Future<AchievementEntity?> getUserAchievement(String userId, int achievementId);
}
