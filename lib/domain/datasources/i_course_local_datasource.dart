import 'package:codium/data/database/app_database.dart';

abstract interface class ICourseLocalDataSource {
  Future<List<CourseEntity>> getAllCourses();
  Future<List<CourseEntity>> getUserCourses(int userId);
  Future<CourseEntity?> getCourseById(int courseId);
  Future<List<CourseEntity>> getCoursesByCategory(String category);
  Future<CourseEntity> insertCourse(CourseCompanion entry);
  Future<void> updateCourse(CourseCompanion entry);
}
