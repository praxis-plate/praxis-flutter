import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/models/module/module_model.dart';
import 'package:codium/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
import 'package:codium/domain/usecases/modules/get_modules_by_course_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/get_completed_task_count_by_lesson_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/get_task_count_by_lesson_id_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lessons_list_event.dart';
part 'lessons_list_state.dart';

class LessonsListBloc extends Bloc<LessonsListEvent, LessonsListState> {
  final GetModulesByCourseIdUseCase _getModulesByCourseIdUseCase;
  final GetLessonsByCourseIdUseCase _getLessonsByCourseIdUseCase;
  final GetTaskCountByLessonIdUseCase _getTaskCountByLessonIdUseCase;
  final GetCompletedTaskCountByLessonIdUseCase
      _getCompletedTaskCountByLessonIdUseCase;

  LessonsListBloc(
    this._getModulesByCourseIdUseCase,
    this._getLessonsByCourseIdUseCase,
    this._getTaskCountByLessonIdUseCase,
    this._getCompletedTaskCountByLessonIdUseCase,
  ) : super(const LessonsListInitialState()) {
    on<LoadLessonsListEvent>(_onLoadLessonsList);
  }

  Future<void> _onLoadLessonsList(
    LoadLessonsListEvent event,
    Emitter<LessonsListState> emit,
  ) async {
    emit(const LessonsListLoadingState());
    try {
      final result = await _getLessonsByCourseIdUseCase(event.courseId);
      final modulesResult = await _getModulesByCourseIdUseCase(event.courseId);

      if (result.isSuccess) {
        final lessons = result.dataOrNull!;
        final modules = modulesResult.dataOrNull ?? <ModuleModel>[];
        final taskCounts = <int, int?>{};
        final completedTaskCounts = <int, int>{};

        for (final lesson in lessons) {
          final taskCountResult = await _getTaskCountByLessonIdUseCase(
            lesson.id,
          );
          taskCounts[lesson.id] = taskCountResult.dataOrNull;

          final completedResult = await _getCompletedTaskCountByLessonIdUseCase(
            event.userId,
            lesson.id,
          );
          completedTaskCounts[lesson.id] = completedResult.dataOrNull ?? 0;
        }

        emit(
          LessonsListLoadedState(
            modules: modules,
            lessons: lessons,
            taskCounts: taskCounts,
            completedTaskCounts: completedTaskCounts,
          ),
        );
      } else {
        emit(LessonsListErrorState(failure: result.failureOrNull!));
      }
    } catch (e) {
      emit(LessonsListErrorState(failure: AppFailure.fromException(e)));
    }
  }
}
