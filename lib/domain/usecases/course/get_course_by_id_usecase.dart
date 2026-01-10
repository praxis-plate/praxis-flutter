import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';

class GetCourseByIdUseCase {
  final ICourseRepository _courseRepository;

  GetCourseByIdUseCase(this._courseRepository);

  Future<Result<CourseModel>> call(int courseId) async {
    return _courseRepository.getCourseById(courseId);
  }
}
