import 'package:praxis/data/database/tables/lesson.dart';
import 'package:praxis/domain/enums/task_type.dart';
import 'package:drift/drift.dart';

@DataClassName('TaskEntity')
class Task extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId =>
      integer().references(Lesson, #id, onDelete: KeyAction.cascade)();
  TextColumn get taskType => textEnum<TaskType>()();
  TextColumn get questionText => text()();
  TextColumn get correctAnswer => text()();
  TextColumn get optionsJson => text().nullable()();
  TextColumn get codeTemplate => text().nullable()();
  TextColumn get testCasesJson => text().nullable()();
  TextColumn get programmingLanguage => text().nullable()();
  IntColumn get difficultyLevel => integer()();
  IntColumn get xpValue => integer()();
  IntColumn get orderIndex => integer()();
  TextColumn get fallbackHint => text().nullable()();
  TextColumn get fallbackExplanation => text().nullable()();
  TextColumn get topic => text()();
  DateTimeColumn get createdAt => dateTime()();
}
