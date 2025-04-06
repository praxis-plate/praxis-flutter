import 'package:codium/domain/models/models.dart';

abstract interface class ICourseDataSource {
  Future<Course> fetchCourseById(String id);
  Future<List<Course>> fetchCourses(int limit);
}
 