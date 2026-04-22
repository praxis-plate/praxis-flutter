import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';
import 'package:praxis/domain/repositories/i_lesson_repository.dart';

class GetLessonsByCourseIdUseCase {
  final ILessonRepository _lessonRepository;

  const GetLessonsByCourseIdUseCase(this._lessonRepository);

  Future<Result<List<LessonModel>>> call(int courseId) async {
    return _lessonRepository.getLessonsByCourseId(courseId);
  }
}
