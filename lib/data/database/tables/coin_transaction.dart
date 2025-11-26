import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('CoinTransactionEntity')
class CoinTransaction extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer()();
  TextColumn get type => text()();
  TextColumn get relatedEntityId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
