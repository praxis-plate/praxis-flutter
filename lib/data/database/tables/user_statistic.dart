import 'package:praxis/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserStatisticEntity')
class UserStatistic extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get maxStreak => integer().withDefault(const Constant(0))();
  IntColumn get coinBalance => integer().withDefault(const Constant(0))();
  IntColumn get experiencePoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime()();
}
