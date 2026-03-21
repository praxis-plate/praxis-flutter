import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/achievement/achievement_data_model.dart';

abstract interface class IAchievementRepository {
  Future<Result<List<AchievementModel>>> getUserAchievements(String userId);
  Future<Result<void>> unlockAchievement(String userId, int achievementId);
  Future<Result<bool>> isAchievementUnlocked(String userId, int achievementId);
  Future<Result<List<AchievementModel>>> getAllAchievements();
}
