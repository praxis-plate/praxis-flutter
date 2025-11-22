import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';

class GetCourseDetailUseCase {
  final ICourseRepository _courseRepository;

  GetCourseDetailUseCase(this._courseRepository);

  Future<Course> call(String courseId) async {
    try {
      return await _courseRepository.getCourseById(courseId);
    } catch (e) {
      rethrow;
    }
  }
}
