import 'package:drift/drift.dart';

@DataClassName('CourseEntity')
class Course extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get author => text()();
  TextColumn get category => text()();
  IntColumn get priceInCoins => integer()();
  IntColumn get durationMinutes => integer()();
  RealColumn get rating => real().withDefault(const Constant(0))();
  TextColumn get thumbnailUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
