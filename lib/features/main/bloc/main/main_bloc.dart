import 'package:codium/domain/models/course/course.dart';
import 'package:codium/domain/usecases/get_courses_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final GetCoursesUseCase _getCoursesUseCase;

  MainBloc({required GetCoursesUseCase getCoursesUseCase})
      : _getCoursesUseCase = getCoursesUseCase,
        super(MainCoursesInitialState()) {
    on<MainLoadCoursesEvent>(_onLoadCourses);
  }

  Future<void> _onLoadCourses(
    MainLoadCoursesEvent event,
    Emitter<MainState> emit,
  ) async {
    emit(MainCoursesLoadingState());
    try {
      final courses = await _getCoursesUseCase.execute();
      emit(MainCoursesLoadSuccessState(courses));
    } catch (e) {
      emit(MainCoursesLoadErrorState(e.toString()));
    }
  }
}
