import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';

class CheckCourseEnrollmentUseCase {
  final ICourseRepository _courseRepository;

  CheckCourseEnrollmentUseCase({required ICourseRepository courseRepository})
    : _courseRepository = courseRepository;

  Future<Result<bool>> call({
    required String userId,
    required int courseId,
  }) async {
    final result = await _courseRepository.getEnrolledCourses(userId);

    return result.when(
      success: (courses) {
        final isEnrolled = courses.any((course) => course.id == courseId);
        return Success(isEnrolled);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
