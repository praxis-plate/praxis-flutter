import 'package:drift/drift.dart';

@DataClassName('UserEntity')
class User extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  DateTimeColumn get createdAt => dateTime()();
}
