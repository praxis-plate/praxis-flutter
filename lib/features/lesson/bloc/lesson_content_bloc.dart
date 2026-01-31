import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/achievement/achievement_data_model.dart';
import 'package:codium/domain/models/task/course_task.dart';
import 'package:codium/domain/usecases/lesson/complete_lesson_usecase.dart';
import 'package:codium/domain/usecases/lesson/get_lesson_by_id_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'lesson_content_event.dart';
part 'lesson_content_state.dart';

class LessonContentBloc extends Bloc<LessonContentEvent, LessonContentState> {
  final GetLessonByIdUseCase _getLessonByIdUseCase;
  final CompleteLessonUseCase _completeLessonUseCase;

  LessonContentBloc({
    required GetLessonByIdUseCase getLessonByIdUseCase,
    required CompleteLessonUseCase completeLessonUseCase,
  }) : _getLessonByIdUseCase = getLessonByIdUseCase,
       _completeLessonUseCase = completeLessonUseCase,
       super(const LessonContentInitial()) {
    on<LoadLessonContent>(_onLoadLessonContent);
    on<CompleteLesson>(_onCompleteLesson);
  }

  Future<void> _onLoadLessonContent(
    LoadLessonContent event,
    Emitter<LessonContentState> emit,
  ) async {
    emit(const LessonContentLoading());
    try {
      final lessonId = int.tryParse(event.lessonId) ?? 0;

      final lessonResult = await _getLessonByIdUseCase.call(lessonId);

      lessonResult.when(
        success: (lesson) {
          if (lesson != null) {
            // For now, we'll assume lesson is not completed until we have proper progress tracking
            const isCompleted = false;
            final task = CourseTask(
              id: lesson.id,
              title: lesson.title,
              description: lesson.contentText,
              moduleId: lesson.moduleId,
              orderIndex: lesson.orderIndex,
            );
            emit(LessonContentLoaded(lesson: task, isCompleted: isCompleted));
          } else {
            emit(const LessonContentError(message: 'Lesson not found'));
          }
        },
        failure: (failure) {
          emit(LessonContentError(message: failure.message));
        },
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(LessonContentError(message: e.toString()));
    }
  }

  Future<void> _onCompleteLesson(
    CompleteLesson event,
    Emitter<LessonContentState> emit,
  ) async {
    emit(const LessonContentCompleting());
    try {
      final userId = event.userId;
      final lessonId = int.tryParse(event.lessonId) ?? 0;

      final result = await _completeLessonUseCase(
        userId: userId,
        lessonId: lessonId,
      );

      result.when(
        success: (_) {
          emit(const LessonContentCompleted(coinsEarned: 10, achievements: []));
        },
        failure: (failure) {
          emit(LessonContentError(message: failure.message));
        },
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(LessonContentError(message: e.toString()));
    }
  }
}
