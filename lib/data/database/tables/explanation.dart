import 'package:drift/drift.dart';

@DataClassName('ExplanationEntity')
class Explanation extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get selectedText => text()();
  TextColumn get explanation => text()();
  TextColumn get sources => text()();
  DateTimeColumn get createdAt => dateTime()();
}
