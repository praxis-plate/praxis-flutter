import 'package:codium/data/database/tables/course.dart';
import 'package:drift/drift.dart';

class Module extends Table {
  TextColumn get id => text()();
  TextColumn get courseId =>
      text().references(Course, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
