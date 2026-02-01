import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/user/money.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';

extension UserStatisticEntityExtension on UserStatisticEntity {
  UserStatisticModel toDomain() {
    return UserStatisticModel(
      id: id,
      userId: userId,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      balance: Money(amount: coinBalance),
      experiencePoints: experiencePoints,
      lastActiveDate: lastActiveDate,
    );
  }
}
