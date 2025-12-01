import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/user/money.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';
import 'package:codium/domain/models/user_statistic/create_user_statistic_model.dart';
import 'package:codium/domain/models/user_statistic/update_user_statistic_model.dart';
import 'package:drift/drift.dart';

extension UserStatisticEntityExtension on UserStatisticEntity {
  UserStatisticModel toDomain() {
    return UserStatisticModel(
      userId: userId,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      balance: Money(amount: points),
      lastActiveDate: lastActiveDate,
    );
  }
}

extension CreateUserStatisticModelExtension on CreateUserStatisticModel {
  UserStatisticCompanion toCompanion() {
    return UserStatisticCompanion.insert(
      userId: userId,
      lastActiveDate: DateTime.now(),
    );
  }
}

extension UpdateUserStatisticModelExtension on UpdateUserStatisticModel {
  UserStatisticCompanion toCompanion() {
    return UserStatisticCompanion(
      id: Value(id),
      currentStreak: currentStreak != null
          ? Value(currentStreak!)
          : const Value.absent(),
      maxStreak: maxStreak != null ? Value(maxStreak!) : const Value.absent(),
      points: points != null ? Value(points!) : const Value.absent(),
      lastActiveDate: lastActiveDate != null
          ? Value(lastActiveDate!)
          : const Value.absent(),
    );
  }
}
