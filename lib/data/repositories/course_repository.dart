import 'package:codium/core/exceptions/app_exception.dart';
import 'package:codium/domain/datasources/abstract_course_datasource.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';

class CourseRepository implements ICourseRepository {
  final ICourseDataSource _dataSource;

  CourseRepository(this._dataSource);

  @override
  Future<Course> getCourseById(String id) async {
    try {
      return await _dataSource.fetchCourseById(id);
    } catch (e) {
      throw ApiError.notFound(
        message: 'Failed to fetch course: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Course>> getCourses([int limit = 10]) async {
    try {
      return await _dataSource.fetchCourses(limit);
    } catch (e) {
      throw ApiError.general(
        message: 'Failed to fetch courses: ${e.toString()}',
      );
    }
  }
}
