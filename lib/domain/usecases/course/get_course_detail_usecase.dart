import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';

class GetCourseDetailUseCase {
  final ICourseRepository _courseRepository;

  GetCourseDetailUseCase(this._courseRepository);

  Future<Result<CourseModel>> call(int courseId) async {
    return await _courseRepository.getCourseById(courseId);
  }
}
