import 'package:praxis/data/database/tables/course.dart';
import 'package:drift/drift.dart';

@DataClassName('AchievementEntity')
class Achievement extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get iconUrl => text().nullable()();
  IntColumn get pointsReward => integer().withDefault(const Constant(0))();
  IntColumn get relatedCourseId => integer().nullable().references(
    Course,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get conditionType => text()();
  TextColumn get conditionValue => text().nullable()();
}
