import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';
import 'package:praxis_client/praxis_client.dart';

class GetCourseTableOfContentsUseCase {
  final ICourseRepository _courseRepository;

  const GetCourseTableOfContentsUseCase(this._courseRepository);

  Future<Result<CourseStructureDto>> call(int courseId) async {
    return await _courseRepository.getTableOfContents(courseId);
  }
}
