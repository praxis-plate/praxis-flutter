import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course_content/course_content_model.dart';
import 'package:codium/domain/repositories/i_course_content_repository.dart';

class GetCourseDetailUseCase {
  final ICourseContentRepository _courseContentRepository;

  GetCourseDetailUseCase(this._courseContentRepository);

  Future<Result<CourseContentModel>> call(int courseId) async {
    return await _courseContentRepository.getCourseContentById(courseId);
  }
}
