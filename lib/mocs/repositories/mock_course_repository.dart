import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';
import 'package:codium/mocs/data/mock_courses.dart';

class MockCourseRepository implements ICourseRepository {

  @override
  Future<List<Course>> getCourses([int limit = 10]) async {
    return mockCourses;
  }

  @override
  Future<Course> getCourseById(String id) async {
    return mockCourses.firstWhere((course) => course.id == id);
  }
}