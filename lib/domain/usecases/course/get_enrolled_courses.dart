import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';

class GetEnrolledCoursesUseCase {
  final ICourseRepository _courseRepository;

  GetEnrolledCoursesUseCase({required ICourseRepository courseRepository})
    : _courseRepository = courseRepository;

  Future<Result<List<CourseModel>>> call(String userId) async {
    return await _courseRepository.getEnrolledCourses(userId);
  }
}
