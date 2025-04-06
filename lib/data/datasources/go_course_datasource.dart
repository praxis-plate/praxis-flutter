import 'package:codium/domain/datasources/abstract_course_datasource.dart';
import 'package:codium/domain/models/course/course.dart';

class GoCourseDatasource implements ICourseDataSource {
  @override
  Future<Course> fetchCourseById(String id) {
    // TODO: implement fetchCourse
    throw UnimplementedError();
  }

  @override
  Future<List<Course>> fetchCourses(int limit) {
    // TODO: implement fetchCourses
    throw UnimplementedError();
  }
}
