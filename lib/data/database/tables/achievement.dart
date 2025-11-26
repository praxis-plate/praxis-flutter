import 'package:codium/data/database/tables/course.dart';
import 'package:drift/drift.dart';

@DataClassName('AchievementEntity')
class Achievement extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get iconUrl => text().nullable()();
  IntColumn get pointsReward => integer().withDefault(const Constant(0))();
  TextColumn get relatedCourseId =>
      text().nullable().references(Course, #id, onDelete: KeyAction.cascade)();
  TextColumn get conditionType => text()();
  TextColumn get conditionValue => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
