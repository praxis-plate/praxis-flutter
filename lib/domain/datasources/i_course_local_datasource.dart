import 'package:codium/data/database/app_database.dart';

abstract interface class ICourseLocalDataSource {
  Future<List<CourseEntity>> getAllCourses();
  Future<CourseEntity?> getCourseById(int courseId);
  Future<CourseEntity> insertCourse(CourseCompanion entry);
  Future<void> updateCourse(CourseCompanion entry);
  Future<List<CourseEntity>> getEnrolledCourses(String userId);
  Future<void> enrollUserInCourse(UserCourseCompanion entry);
  Future<bool> isUserEnrolled(String userId, int courseId);
}
