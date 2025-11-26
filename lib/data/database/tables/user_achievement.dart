import 'package:codium/data/database/tables/achievement.dart';
import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserAchievementEntity')
class UserAchievement extends Table {
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  TextColumn get achievementId =>
      text().references(Achievement, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, achievementId};
}
