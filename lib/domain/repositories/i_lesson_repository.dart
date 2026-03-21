import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';

abstract interface class ILessonRepository {
  Future<Result<List<LessonModel>>> getLessonsByModuleId(int moduleId);
  Future<Result<List<LessonModel>>> getLessonsByCourseId(int courseId);
  Future<Result<LessonModel?>> getLessonById(int lessonId);
}
