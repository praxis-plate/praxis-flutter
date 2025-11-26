import 'package:codium/data/database/tables/course.dart';
import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserCourseEntity')
class UserCourse extends Table {
  TextColumn get userId =>
      text().references(User, #id, onDelete: KeyAction.cascade)();
  TextColumn get courseId =>
      text().references(Course, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get enrolledAt => dateTime().withDefault(currentDate)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {userId, courseId};
}
