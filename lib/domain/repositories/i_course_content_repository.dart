import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course_content/course_content_model.dart';

abstract interface class ICourseContentRepository {
  Future<Result<CourseContentModel>> getCourseContentById(int id);
}
