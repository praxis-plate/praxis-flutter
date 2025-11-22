import 'package:codium/domain/datasources/datasources.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/mocs/data/mock_courses.dart';

class GoCourseDatasource implements ICourseDataSource {
  @override
  Future<Course> fetchCourseById(String id) async {
    try {
      return mockCourses.firstWhere((course) => course.id == id);
    } catch (e) {
      throw Exception('Course with id $id not found');
    }
  }

  @override
  Future<List<Course>> fetchCourses(int limit) async {
    return mockCourses.take(limit).toList();
  }
}
