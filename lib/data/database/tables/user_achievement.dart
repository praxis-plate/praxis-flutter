import 'package:codium/data/database/tables/achievement.dart';
import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserAchievementEntity')
class UserAchievement extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId =>
      integer().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get achievementId =>
      integer().references(Achievement, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
