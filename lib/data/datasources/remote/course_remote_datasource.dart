import 'package:praxis_client/praxis_client.dart';

class CourseRemoteDataSource {
  final Client _client;

  const CourseRemoteDataSource(this._client);

  Future<List<CourseDto>> getAllCourses() async {
    return await _client.course.get(limit: 100, offset: 0);
  }

  Future<CourseDetailDto?> getCourseById(int courseId) async {
    return await _client.course.getById(courseId);
  }

  Future<List<CourseDto>> getEnrolledCourses() async {
    return await _client.course.getEnrolled();
  }

  Future<void> enrollUserInCourse(int courseId) async {
    await _client.course.enroll(courseId);
  }
}
