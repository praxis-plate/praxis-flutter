import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_structure_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';

class GetCourseTableOfContentsUseCase {
  final ICourseRepository _courseRepository;

  const GetCourseTableOfContentsUseCase(this._courseRepository);

  Future<Result<CourseStructureModel>> call(int courseId) async {
    return await _courseRepository.getTableOfContents(courseId);
  }
}
