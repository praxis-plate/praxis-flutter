import 'package:praxis_client/praxis_client.dart';

class AchievementRemoteDataSource {
  final Client _client;

  const AchievementRemoteDataSource(this._client);

  Future<List<AchievementDto>> getAllAchievements() async {
    return await _client.achievement.getAll();
  }

  Future<AchievementDto?> getAchievementById(int id) async {
    final achievements = await _client.achievement.getAll();
    return achievements.where((a) => a.id == id).firstOrNull;
  }

  Future<List<AchievementDto>> getUserAchievements() async {
    return await _client.achievement.getUserAchievements();
  }

  Future<void> unlockAchievement(int achievementId) async {
    await _client.achievement.unlock(achievementId);
  }

  Future<bool> isAchievementUnlocked(int achievementId) async {
    return await _client.achievement.isUnlocked(achievementId);
  }
}
