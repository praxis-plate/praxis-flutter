import 'package:praxis/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('CoinTransactionEntity')
class CoinTransaction extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer()();
  TextColumn get type => text()();
  TextColumn get relatedEntityId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
