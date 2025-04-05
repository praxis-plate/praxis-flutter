import 'package:codium/repositories/codium_courses/abstract_course_repository.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_carousel_event.dart';
part 'main_carousel_state.dart';

class MainCarouselBloc extends Bloc<MainCarouselEvent, MainCarouselState> {
  final ICourseRepository courseRepository;

  MainCarouselBloc(this.courseRepository) : super(MainCarouselInitialState()) {
    on<MainCarouselLoadEvent>(_onCarouselLoadCourses);
  }

  Future<void> _onCarouselLoadCourses(
    MainCarouselLoadEvent event,
    Emitter<MainCarouselState> emit,
  ) async {
    emit(MainCarouselLoadingState());
    try {
      final courses = await courseRepository.getCourses();
      emit(MainCarouselLoadSuccessState(courses));
    } catch (e) {
      emit(MainCarouselLoadErrorState(e.toString()));
    }
  }
}
