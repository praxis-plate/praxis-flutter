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
    on<SearchCoursesEvent>(_onSearchCourses);
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

  void _onSearchCourses(SearchCoursesEvent event, Emitter<MainState> emit) {
    if (state is MainCoursesLoadSuccessState) {
      final currentState = state as MainCoursesLoadSuccessState;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredCourses: currentState.courses,
            searchQuery: '',
          ),
        );
      } else {
        final filtered = currentState.courses.where((course) {
          return course.title.toLowerCase().contains(query) ||
              course.description.toLowerCase().contains(query);
        }).toList();

        emit(
          currentState.copyWith(filteredCourses: filtered, searchQuery: query),
        );
      }
    }
  }
}
