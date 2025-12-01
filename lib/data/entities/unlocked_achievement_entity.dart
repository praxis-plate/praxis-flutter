import 'package:codium/domain/models/achievement/achievement_data_model.dart';

class UnlockedAchievementEntity {
  final int id;
  final String title;
  final String description;
  final String? iconUrl;
  final int pointsReward;
  final DateTime unlockedAt;

  const UnlockedAchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.pointsReward,
    required this.unlockedAt,
  });

  AchievementModel toDomain() {
    return AchievementModel(
      id: id,
      title: title,
      description: description,
      iconUrl: iconUrl,
      unlockedAt: unlockedAt,
    );
  }
}
