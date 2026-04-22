import 'package:praxis/data/database/tables/achievement.dart';
import 'package:praxis/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserAchievementEntity')
class UserAchievement extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get achievementId =>
      integer().references(Achievement, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get unlockedAt => dateTime()();
}
