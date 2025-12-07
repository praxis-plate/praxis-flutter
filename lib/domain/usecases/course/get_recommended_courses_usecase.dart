import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';

class GetRecommendedCoursesUseCase {
  final ICourseRepository _courseRepository;
  static const _minRecommendRating = 0.6;

  GetRecommendedCoursesUseCase(this._courseRepository);

  Future<Result<List<CourseModel>>> call(String userId) async {
    final coursesResult = await _courseRepository.getCourses(5);

    return coursesResult.when(
      success: (courses) {
        final recommended = courses
            .where((c) => c.rating >= _minRecommendRating)
            .toList();
        return Success(recommended);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
