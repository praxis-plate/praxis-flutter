import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';
import 'package:praxis/domain/repositories/i_lesson_repository.dart';

class GetLessonByIdUseCase {
  final ILessonRepository _lessonRepository;

  const GetLessonByIdUseCase(this._lessonRepository);

  Future<Result<LessonModel?>> call(int lessonId) async {
    return await _lessonRepository.getLessonById(lessonId);
  }
}
