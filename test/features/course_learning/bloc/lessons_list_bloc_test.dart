import 'package:bloc_test/bloc_test.dart';
import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/models/module/module_model.dart';
import 'package:codium/domain/models/task/task_model.dart';
import 'package:codium/domain/repositories/i_lesson_repository.dart';
import 'package:codium/domain/repositories/i_module_repository.dart';
import 'package:codium/domain/repositories/i_task_repository.dart';
import 'package:codium/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
import 'package:codium/domain/usecases/modules/get_modules_by_course_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/get_completed_task_count_by_lesson_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/get_task_count_by_lesson_id_usecase.dart';
import 'package:codium/features/course_learning/bloc/lesson/lessons_list_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockLessonRepository extends Mock implements ILessonRepository {}

class _MockModuleRepository extends Mock implements IModuleRepository {}

class _MockTaskRepository extends Mock implements ITaskRepository {}

void main() {
  late _MockLessonRepository lessonRepository;
  late _MockModuleRepository moduleRepository;
  late _MockTaskRepository taskRepository;
  late LessonsListBloc bloc;

  setUp(() {
    lessonRepository = _MockLessonRepository();
    moduleRepository = _MockModuleRepository();
    taskRepository = _MockTaskRepository();

    bloc = LessonsListBloc(
      GetModulesByCourseIdUseCase(moduleRepository),
      GetLessonsByCourseIdUseCase(lessonRepository),
      GetTaskCountByLessonIdUseCase(taskRepository),
      GetCompletedTaskCountByLessonIdUseCase(taskRepository),
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  blocTest<LessonsListBloc, LessonsListState>(
    'loads lessons and task counts into bloc state',
    setUp: () {
      when(
        () => lessonRepository.getLessonsByCourseId(1),
      ).thenAnswer((_) async => Success(_lessons));
      when(
        () => moduleRepository.getModulesByCourseId(1),
      ).thenAnswer((_) async => Success(_modules));
      when(
        () => taskRepository.getTasksByLessonId(1),
      ).thenAnswer((_) async => const Success(<TaskModel>[]));
      when(
        () => taskRepository.getTasksByLessonId(2),
      ).thenAnswer((_) async => const Failure(_failure));
      when(
        () => taskRepository.getCompletedTaskCount('user-1', 1),
      ).thenAnswer((_) async => const Success(0));
      when(
        () => taskRepository.getCompletedTaskCount('user-1', 2),
      ).thenAnswer((_) async => const Failure(_failure));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(
      const LoadLessonsListEvent(courseId: 1, userId: 'user-1'),
    ),
    expect: () => [
      const LessonsListLoadingState(),
      LessonsListLoadedState(
        modules: _modules,
        lessons: _lessons,
        taskCounts: const {1: 0, 2: null},
        completedTaskCounts: const {1: 0, 2: 0},
      ),
    ],
  );
}

const _failure = AppFailure(
  code: AppErrorCode.unknown,
  message: 'Task loading failed',
);

final _lessons = [
  LessonModel(
    id: 1,
    moduleId: 10,
    title: 'Intro',
    contentText: 'content',
    orderIndex: 0,
    durationMinutes: 5,
    createdAt: DateTime(2026, 3, 9),
  ),
  LessonModel(
    id: 2,
    moduleId: 10,
    title: 'Practice',
    contentText: 'content',
    orderIndex: 1,
    durationMinutes: 10,
    createdAt: DateTime(2026, 3, 9),
  ),
];

final _modules = [
  ModuleModel(
    id: 10,
    courseId: 1,
    title: 'Basics',
    description: 'Intro module',
    orderIndex: 0,
    createdAt: DateTime(2026, 3, 9),
  ),
];
