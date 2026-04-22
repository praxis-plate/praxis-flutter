import 'package:praxis/data/database/tables/task.dart';
import 'package:drift/drift.dart';

@DataClassName('TaskOptionEntity')
class TaskOption extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId =>
      integer().references(Task, #id, onDelete: KeyAction.cascade)();
  TextColumn get optionText => text()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get orderIndex => integer()();
}
