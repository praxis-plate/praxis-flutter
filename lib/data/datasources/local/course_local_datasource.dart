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
  Future<List<CourseEntity>> getUserCourses(int userId) async {
    final userCourses = await _db.managers.userCourse
        .filter((f) => f.userId.id(userId))
        .get();

    final courseIds = userCourses.map((e) => e.courseId).toList();

    final courses = await _db.managers.course
        .filter((f) => f.id.isIn(courseIds))
        .get();

    return courses;
  }

  @override
  Future<CourseEntity?> getCourseById(int courseId) async {
    return await _db.managers.course
        .filter((f) => f.id(courseId))
        .getSingleOrNull();
  }

  @override
  Future<List<CourseEntity>> getCoursesByCategory(String category) async {
    return await _db.managers.course.filter((f) => f.category(category)).get();
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
}
