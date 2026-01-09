import 'package:codium/data/database/tables/task.dart';
import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('TaskProgressEntity')
class TaskProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId =>
      integer().references(Task, #id, onDelete: KeyAction.cascade)();
  IntColumn get userId =>
      integer().references(User, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get hintsUsed => integer().withDefault(const Constant(0))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  TextColumn get userAnswer => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime()();
}
