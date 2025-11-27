import 'package:codium/data/database/tables/course.dart';
import 'package:drift/drift.dart';

@DataClassName('ModuleEntity')
class Module extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId =>
      integer().references(Course, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get createdAt => dateTime()();
}
