import 'package:codium/domain/models/course/course.dart';

abstract interface class ICourseRepository {
  Future<List<Course>> getCourses([int limit = 10]);
  Future<Course> getCourseById(String id);
}
