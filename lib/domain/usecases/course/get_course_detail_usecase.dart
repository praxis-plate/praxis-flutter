import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';

class GetCourseDetailUseCase {
  final ICourseRepository _courseRepository;

  GetCourseDetailUseCase(this._courseRepository);

  Future<Result<CourseModel>> call(int courseId) async {
    return await _courseRepository.getCourseById(courseId.toString());
  }
}
