import 'package:codium/data/database/tables/module.dart';
import 'package:drift/drift.dart';

class Lesson extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get moduleId =>
      text().references(Module, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get contentText => text()();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get imageUrls => text().nullable()();
  IntColumn get orderIndex => integer()();
  IntColumn get durationMinutes => integer()();
  DateTimeColumn get createdAt => dateTime()();
}
