import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final GetCoursesUseCase _getCoursesUseCase;
  final GetEnrolledCoursesUseCase _getEnrolledCoursesUseCase;

  MainBloc({
    required GetCoursesUseCase getCoursesUseCase,
    required GetEnrolledCoursesUseCase getEnrolledCoursesUseCase,
  }) : _getCoursesUseCase = getCoursesUseCase,
       _getEnrolledCoursesUseCase = getEnrolledCoursesUseCase,
       super(const MainCoursesLoadingState()) {
    on<MainLoadCoursesEvent>(_onLoadCourses);
    on<SearchCoursesEvent>(_onSearchCourses);
  }

  Future<void> _onLoadCourses(
    MainLoadCoursesEvent event,
    Emitter<MainState> emit,
  ) async {
    emit(const MainCoursesLoadingState());
    try {
      final coursesResult = await _getCoursesUseCase();
      final enrolledResult = await _getEnrolledCoursesUseCase(event.userId);

      if (coursesResult.isSuccess && enrolledResult.isSuccess) {
        final courses = coursesResult.dataOrNull ?? [];
        final enrolledCourses = enrolledResult.dataOrNull ?? [];
        final enrolledIds = enrolledCourses.map((c) => c.id).toSet();

        emit(MainCoursesLoadSuccessState(courses, enrolledIds));
      } else {
        emit(
          MainCoursesLoadErrorState(
            coursesResult.failureOrNull?.message ??
                enrolledResult.failureOrNull?.message ??
                'Unknown error',
          ),
        );
      }
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

        filtered.sort((a, b) => b.rating.compareTo(a.rating));

        emit(
          currentState.copyWith(filteredCourses: filtered, searchQuery: query),
        );
      }
    }
  }
}
