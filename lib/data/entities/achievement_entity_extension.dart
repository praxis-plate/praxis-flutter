import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/achievement/achievement_data_model.dart';

extension AchievementEntityExtension on AchievementEntity {
  AchievementModel toDomain() {
    return AchievementModel(
      id: id,
      title: title,
      description: description,
      iconUrl: iconUrl,
      unlockedAt: null,
    );
  }
}
