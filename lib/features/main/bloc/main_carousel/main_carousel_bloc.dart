import 'package:codium/domain/models/course/course.dart';
import 'package:codium/domain/usecases/get_main_carousel_courses.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_carousel_event.dart';
part 'main_carousel_state.dart';

class MainCarouselBloc extends Bloc<MainCarouselEvent, MainCarouselState> {
  final GetMainCarouselCoursesUseCase _getMainCarouselCoursesUseCase;

  MainCarouselBloc({
    required GetMainCarouselCoursesUseCase getMainCarouselCoursesUseCase,
  })  : _getMainCarouselCoursesUseCase = getMainCarouselCoursesUseCase,
        super(MainCarouselInitialState()) {
    on<MainCarouselLoadEvent>(_onCarouselLoadCourses);
  }

  Future<void> _onCarouselLoadCourses(
    MainCarouselLoadEvent event,
    Emitter<MainCarouselState> emit,
  ) async {
    emit(MainCarouselLoadingState());
    try {
      final courses = await _getMainCarouselCoursesUseCase.execute();
      emit(MainCarouselLoadSuccessState(courses));
    } catch (e) {
      emit(MainCarouselLoadErrorState(e.toString()));
    }
  }
}
