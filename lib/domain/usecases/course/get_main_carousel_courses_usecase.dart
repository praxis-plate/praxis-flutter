import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';

class GetMainCarouselCoursesUseCase {
  final ICourseRepository _courseRepository;

  GetMainCarouselCoursesUseCase(this._courseRepository);

  Future<Result<List<CourseModel>>> call() async {
    return await _courseRepository.getCourses();
  }
}
