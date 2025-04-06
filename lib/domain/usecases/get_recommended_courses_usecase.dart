import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/repositories.dart';

class GetRecommendedCoursesUseCase {
  final ICourseRepository _courseRepository;
  static const _minRecommendRating = 0.6;

  GetRecommendedCoursesUseCase(this._courseRepository);

  Future<List<Course>> execute(String userId) async {
    final courses = await _courseRepository.getCourses(5);
    return _filterRecommendedCourses(courses);
  }

  List<Course> _filterRecommendedCourses(List<Course> courses) {
    return courses
        .where((c) => c.statistics.averageRating > _minRecommendRating)
        .toList();
  }
}
