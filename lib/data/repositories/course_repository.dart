import 'package:codium/domain/datasources/abstract_course_datasource.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';

class CourseRepository implements ICourseRepository {
  final ICourseDataSource _dataSource;

  CourseRepository(this._dataSource);

  @override
  Future<Course> getCourseById(String id) {
    // TODO: implement getCourseById
    throw UnimplementedError();
  }

  @override
  Future<List<Course>> getCourses([int limit = 10]) {
    // TODO: implement getCourses
    throw UnimplementedError();
  }
}
