import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lessons_list_event.dart';
part 'lessons_list_state.dart';

class LessonsListBloc extends Bloc<LessonsListEvent, LessonsListState> {
  final GetLessonsByCourseIdUseCase _getLessonsByCourseIdUseCase;

  LessonsListBloc(this._getLessonsByCourseIdUseCase)
    : super(const LessonsListInitialState()) {
    on<LoadLessonsListEvent>(_onLoadLessonsList);
  }

  Future<void> _onLoadLessonsList(
    LoadLessonsListEvent event,
    Emitter<LessonsListState> emit,
  ) async {
    emit(const LessonsListLoadingState());

    final result = await _getLessonsByCourseIdUseCase(event.courseId);

    if (result.isSuccess) {
      emit(LessonsListLoadedState(lessons: result.dataOrNull!));
    } else {
      emit(LessonsListErrorState(message: result.failureOrNull!.message));
    }
  }
}
