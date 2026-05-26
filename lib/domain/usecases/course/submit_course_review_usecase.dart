import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';

class SubmitCourseReviewUseCase {
  final ICourseRepository _courseRepository;

  SubmitCourseReviewUseCase({required ICourseRepository courseRepository})
    : _courseRepository = courseRepository;

  Future<Result<void>> call({
    required int courseId,
    required int rating,
    required String comment,
  }) {
    return _courseRepository.submitCourseReview(
      courseId: courseId,
      rating: rating,
      comment: comment,
    );
  }
}
