import 'package:codium/data/database/tables/lesson.dart';
import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

class LessonProgress extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId =>
      text().references(Lesson, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
