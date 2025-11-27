import 'package:drift/drift.dart';

@DataClassName('UserEntity')
class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text()();
  DateTimeColumn get createdAt => dateTime()();
}
