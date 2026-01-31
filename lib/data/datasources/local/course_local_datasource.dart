import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_course_local_datasource.dart';

class CourseLocalDataSource implements ICourseLocalDataSource {
  final AppDatabase _db;

  const CourseLocalDataSource(this._db);

  @override
  Future<List<CourseEntity>> getAllCourses() async {
    return await _db.managers.course.get();
  }

  @override
  Future<CourseEntity?> getCourseById(int courseId) async {
    return await _db.managers.course
        .filter((f) => f.id(courseId))
        .getSingleOrNull();
  }

  @override
  Future<CourseEntity> insertCourse(CourseCompanion entry) async {
    return await _db.into(_db.course).insertReturning(entry);
  }

  @override
  Future<void> updateCourse(CourseCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Course id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.course)..where((t) => t.id.equals(id))).write(entry);
  }

  @override
  Future<List<CourseEntity>> getEnrolledCourses(String userId) async {
    final userCourses = await _db.managers.userCourse
        .filter((f) => f.userId.id(userId))
        .get();

    final courseIds = userCourses.map((e) => e.courseId).toList();

    if (courseIds.isEmpty) {
      return [];
    }

    return await _db.managers.course.filter((f) => f.id.isIn(courseIds)).get();
  }

  @override
  Future<void> enrollUserInCourse(UserCourseCompanion entry) async {
    await _db.into(_db.userCourse).insert(entry);
  }

  @override
  Future<bool> isUserEnrolled(String userId, int courseId) async {
    final enrollments = await _db.managers.userCourse
        .filter((f) => f.userId.id(userId))
        .filter((f) => f.courseId.id(courseId))
        .get();

    return enrollments.isNotEmpty;
  }
}
