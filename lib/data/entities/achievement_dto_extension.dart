import 'package:codium/domain/models/achievement/achievement_data_model.dart';
import 'package:praxis_client/praxis_client.dart';

extension AchievementDtoExtension on AchievementDto {
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
