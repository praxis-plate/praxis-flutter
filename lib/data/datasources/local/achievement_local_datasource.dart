import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/entities/unlocked_achievement_entity.dart';
import 'package:drift/drift.dart';

class AchievementLocalDataSource {
  final AppDatabase _db;

  const AchievementLocalDataSource(this._db);

  Future<List<AchievementEntity>> getAllAchievements() async {
    return await _db.managers.achievement.get();
  }

  Future<AchievementEntity?> getAchievementById(int id) async {
    return await _db.managers.achievement
        .filter((f) => f.id(id))
        .getSingleOrNull();
  }

  Future<List<UnlockedAchievementEntity>> getUserAchievements(
    String userId,
  ) async {
    final query = _db.select(_db.userAchievement).join([
      innerJoin(
        _db.achievement,
        _db.achievement.id.equalsExp(_db.userAchievement.achievementId),
      ),
    ])..where(_db.userAchievement.userId.equals(userId));

    final results = await query.get();

    return results.map((row) {
      final userAchievement = row.readTable(_db.userAchievement);
      final achievement = row.readTable(_db.achievement);

      return UnlockedAchievementEntity(
        id: achievement.id,
        title: achievement.title,
        description: achievement.description,
        iconUrl: achievement.iconUrl,
        pointsReward: achievement.pointsReward,
        unlockedAt: userAchievement.unlockedAt,
      );
    }).toList();
  }

  Future<void> insertUserAchievement(
    String userId,
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

  Future<AchievementEntity?> getUserAchievement(
    String userId,
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
