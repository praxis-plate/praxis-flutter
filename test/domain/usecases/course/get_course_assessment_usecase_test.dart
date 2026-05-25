import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';
import 'package:praxis/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:praxis/domain/models/task/task.dart';
import 'package:praxis/domain/repositories/i_lesson_progress_repository.dart';
import 'package:praxis/domain/repositories/i_lesson_repository.dart';
import 'package:praxis/domain/repositories/i_task_repository.dart';
import 'package:praxis/domain/usecases/course/get_course_assessment_usecase.dart';

class _MockLessonRepository extends Mock implements ILessonRepository {}

class _MockLessonProgressRepository extends Mock
    implements ILessonProgressRepository {}

class _MockTaskRepository extends Mock implements ITaskRepository {}

void main() {
  late GetCourseAssessmentUseCase useCase;
  late _MockLessonRepository lessonRepository;
  late _MockLessonProgressRepository lessonProgressRepository;
  late _MockTaskRepository taskRepository;

  setUp(() {
    lessonRepository = _MockLessonRepository();
    lessonProgressRepository = _MockLessonProgressRepository();
    taskRepository = _MockTaskRepository();
    useCase = GetCourseAssessmentUseCase(
      lessonRepository: lessonRepository,
      lessonProgressRepository: lessonProgressRepository,
      taskRepository: taskRepository,
    );
  });

  test('returns grade 4 for 75 percent course accuracy', () async {
    when(
      () => lessonRepository.getLessonsByCourseId(10),
    ).thenAnswer((_) async => Success(_lessons));
    when(
      () => lessonProgressRepository.getCourseLessonProgress('user-1', 10),
    ).thenAnswer((_) async => Success(_progress));
    when(
      () => taskRepository.getTasksByLessonId(1),
    ).thenAnswer((_) async => Success(List.filled(2, _task)));
    when(
      () => taskRepository.getTasksByLessonId(2),
    ).thenAnswer((_) async => Success(List.filled(2, _task)));
    when(
      () => taskRepository.getCompletedTaskCount('user-1', 1),
    ).thenAnswer((_) async => const Success(2));
    when(
      () => taskRepository.getCompletedTaskCount('user-1', 2),
    ).thenAnswer((_) async => const Success(1));

    final result = await useCase.call(userId: 'user-1', courseId: 10);

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull?.accuracyPercentage, 75);
    expect(result.dataOrNull?.grade, 4);
    expect(result.dataOrNull?.isCourseCompleted, isTrue);
  });
}

final _lessons = [
  LessonModel(
    id: 1,
    moduleId: 1,
    title: 'Lesson 1',
    contentText: 'Content',
    orderIndex: 0,
    durationMinutes: 10,
    createdAt: DateTime(2026, 1, 1),
  ),
  LessonModel(
    id: 2,
    moduleId: 1,
    title: 'Lesson 2',
    contentText: 'Content',
    orderIndex: 1,
    durationMinutes: 10,
    createdAt: DateTime(2026, 1, 1),
  ),
];

final _progress = [
  LessonProgressModel(
    id: 1,
    lessonId: 1,
    userId: 'user-1',
    isCompleted: true,
    completedAt: DateTime(2026, 1, 1),
    timeSpentSeconds: 60,
  ),
  LessonProgressModel(
    id: 2,
    lessonId: 2,
    userId: 'user-1',
    isCompleted: true,
    completedAt: DateTime(2026, 1, 1),
    timeSpentSeconds: 60,
  ),
];

final _task = MultipleChoiceTaskModel(
  id: 1,
  lessonId: 1,
  questionText: 'Question',
  correctAnswer: 'Answer',
  options: ['A', 'B'],
  difficultyLevel: 1,
  xpValue: 10,
  orderIndex: 0,
  topic: 'Topic',
  createdAt: DateTime(2026, 1, 1),
);
