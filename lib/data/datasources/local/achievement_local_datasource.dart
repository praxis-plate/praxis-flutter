import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_achievement_local_datasource.dart';

class AchievementLocalDataSource implements IAchievementLocalDataSource {
  final AppDatabase _db;

  const AchievementLocalDataSource(this._db);

  @override
  Future<List<AchievementEntity>> getAllAchievements() async {
    return await _db.managers.achievement.get();
  }

  @override
  Future<AchievementEntity?> getAchievementById(int id) async {
    return await _db.managers.achievement
        .filter((f) => f.id(id))
        .getSingleOrNull();
  }

  @override
  Future<List<AchievementEntity>> getUserAchievements(int userId) async {
    final userAchievements = await _db.managers.userAchievement
        .filter((f) => f.userId.id(userId))
        .get();

    final userAchievementIds = userAchievements
        .map((e) => e.achievementId)
        .toList();

    final achievements = await _db.managers.achievement
        .filter((f) => f.id.isIn(userAchievementIds))
        .get();

    return achievements;
  }

  @override
  Future<void> insertUserAchievement(
    int userId,
    int achievementId,
    DateTime unlockedAt,
  ) async {
    await _db.managers.userAchievement.create(
      (o) => o(
        userId: userId,
        achievementId: achievementId,
        unlockedAt: unlockedAt,
      ),
    );
  }

  @override
  Future<AchievementEntity?> getUserAchievement(
    int userId,
    int achievementId,
  ) async {
    final entity = await _db.managers.userAchievement
        .filter((f) => f.userId.id(userId))
        .filter((f) => f.achievementId.id(achievementId))
        .getSingleOrNull();

    if (entity == null) return null;

    final achievement = await _db.managers.achievement
        .filter((f) => f.id(entity.achievementId))
        .getSingleOrNull();

    return achievement;
  }
}
