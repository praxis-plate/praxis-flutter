import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserStatisticsEntity')
class UserStatistic extends Table {
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get maxStreak => integer().withDefault(const Constant(0))();
  IntColumn get points => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}
