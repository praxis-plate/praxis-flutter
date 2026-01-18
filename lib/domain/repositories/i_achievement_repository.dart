import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/achievement/achievement_data_model.dart';

abstract interface class IAchievementRepository {
  Future<Result<List<AchievementModel>>> getUserAchievements(String userId);
  Future<Result<void>> unlockAchievement(String userId, int achievementId);
  Future<Result<bool>> isAchievementUnlocked(String userId, int achievementId);
  Future<Result<List<AchievementModel>>> getAllAchievements();
}
