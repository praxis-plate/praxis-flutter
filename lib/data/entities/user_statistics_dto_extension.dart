import 'package:codium/domain/models/user/money.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';
import 'package:praxis_client/praxis_client.dart';

extension UserStatisticsDtoExtension on UserStatisticsDto {
  UserStatisticModel toDomain() {
    return UserStatisticModel(
      id: id,
      userId: authUserId,
      lastActiveDate: lastActiveDate,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      balance: Money.zero(), // Will be fetched from wallet
      experiencePoints: experiencePoints,
    );
  }
}
