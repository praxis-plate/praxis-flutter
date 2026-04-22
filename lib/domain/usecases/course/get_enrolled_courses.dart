import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';

class GetEnrolledCoursesUseCase {
  final ICourseRepository _courseRepository;

  GetEnrolledCoursesUseCase({required ICourseRepository courseRepository})
    : _courseRepository = courseRepository;

  Future<Result<List<CourseModel>>> call(String userId) async {
    return await _courseRepository.getEnrolledCourses(userId);
  }
}
