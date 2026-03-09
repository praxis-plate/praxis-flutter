import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/course/course_structure_model.dart';

abstract interface class ICourseRepository {
  Future<Result<List<CourseModel>>> getCourses([int limit = 10]);
  Future<Result<CourseModel>> getCourseById(int id);
  Future<Result<List<CourseModel>>> getEnrolledCourses(String userId);
  Future<Result<void>> enrollUserInCourse(String userId, int courseId);
  Future<Result<bool>> isUserEnrolled(String userId, int courseId);
  Future<Result<CourseStructureModel>> getTableOfContents(int courseId);
}
