import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/achievement/achievement_data_model.dart';

abstract interface class IAchievementRepository {
  Future<Result<List<AchievementModel>>> getUserAchievements(int userId);
  Future<Result<void>> unlockAchievement(int userId, int achievementId);
  Future<Result<bool>> isAchievementUnlocked(int userId, int achievementId);
  Future<Result<List<AchievementModel>>> getAllAchievements();
}
