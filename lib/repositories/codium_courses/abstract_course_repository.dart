import 'package:codium/repositories/codium_courses/models/course.dart';

abstract interface class ICourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> getCourse(String courseId);
}
