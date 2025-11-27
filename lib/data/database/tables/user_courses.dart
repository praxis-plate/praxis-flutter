import 'package:codium/data/database/tables/course.dart';
import 'package:codium/data/database/tables/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserCourseEntity')
class UserCourse extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId =>
      integer().references(User, #id, onDelete: KeyAction.cascade)();
  IntColumn get courseId =>
      integer().references(Course, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get enrolledAt => dateTime().withDefault(currentDate)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
