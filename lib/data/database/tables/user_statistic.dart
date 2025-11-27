import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserStatisticEntity')
class UserStatistic extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId =>
      integer().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get maxStreak => integer().withDefault(const Constant(0))();
  IntColumn get points => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime()();
}
