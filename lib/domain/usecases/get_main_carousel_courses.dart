import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetMainCarouselCoursesUseCase {
  final ICourseRepository _courseRepository;

  GetMainCarouselCoursesUseCase(this._courseRepository);

  Future<List<Course>> execute() async {
    try {
      final courses = await _courseRepository.getCourses();
      return courses;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st, 'Ошибка загрузки карусели курсов');
      rethrow;
    }
  }
}
