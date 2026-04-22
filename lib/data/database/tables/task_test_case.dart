import 'package:praxis/data/database/tables/task.dart';
import 'package:drift/drift.dart';

@DataClassName('TaskTestCaseEntity')
class TaskTestCase extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId =>
      integer().references(Task, #id, onDelete: KeyAction.cascade)();
  TextColumn get input => text()();
  TextColumn get expectedOutput => text()();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
  IntColumn get orderIndex => integer()();
}
