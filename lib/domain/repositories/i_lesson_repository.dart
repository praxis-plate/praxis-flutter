import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson/create_lesson_model.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/models/lesson/update_lesson_model.dart';

abstract interface class ILessonRepository {
  Future<Result<List<LessonModel>>> getLessonsByModuleId(int moduleId);
  Future<Result<List<LessonModel>>> getLessonsByCourseId(int courseId);
  Future<Result<LessonModel?>> getLessonById(int lessonId);
  Future<Result<void>> create(CreateLessonModel model);
  Future<Result<void>> update(UpdateLessonModel model);
}
