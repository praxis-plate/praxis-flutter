import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';

abstract interface class ICourseRepository {
  Future<Result<List<CourseModel>>> getCourses([int limit = 10]);
  Future<Result<CourseModel>> getCourseById(String id);
  Future<Result<List<CourseModel>>> getCoursesByCategory(String category);
  Future<Result<List<CourseModel>>> getEnrolledCourses(int userId);
  Future<Result<void>> enrollUserInCourse(int userId, int courseId);
  Future<Result<bool>> isUserEnrolled(int userId, int courseId);
}
