import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';

class GetCoursesUseCase {
  final ICourseRepository _courseRepository;

  GetCoursesUseCase(this._courseRepository);

  Future<Result<List<CourseModel>>> call() async {
    return await _courseRepository.getCourses();
  }
}
