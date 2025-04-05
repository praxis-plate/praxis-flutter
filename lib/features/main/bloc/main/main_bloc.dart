import 'package:codium/repositories/codium_courses/abstract_course_repository.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final ICourseRepository courseRepository;

  MainBloc(this.courseRepository) : super(MainCoursesInitialState()) {
    on<MainLoadCoursesEvent>(_onLoadCourses);
  }

  Future<void> _onLoadCourses(
    MainLoadCoursesEvent event,
    Emitter<MainState> emit,
  ) async {
    emit(MainCoursesLoadingState());
    try {
      final courses = await courseRepository.getCourses();
      emit(MainCoursesLoadSuccessState(courses));
    } catch (e) {
      emit(MainCoursesLoadErrorState(e.toString()));
    }
  }
}
