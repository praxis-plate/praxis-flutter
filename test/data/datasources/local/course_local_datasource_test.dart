import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/datasources/local/course_local_datasource.dart';
import 'package:praxis/domain/enums/task_type.dart';
import 'package:praxis_client/praxis_client.dart' as client;

void main() {
  late AppDatabase database;
  late CourseLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = CourseLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'replaceCourseDetailSnapshot removes stale content and preserves surviving progress',
    () async {
      await database
          .into(database.user)
          .insert(
            UserCompanion.insert(
              id: 'user-1',
              email: 'user@praxis.app',
              createdAt: DateTime(2026, 3, 9),
            ),
          );

      await database
          .into(database.course)
          .insert(
            CourseCompanion.insert(
              id: const Value(1),
              title: 'Course',
              description: 'Description',
              author: 'Author',
              category: 'Category',
              priceInCoins: 100,
              durationMinutes: 60,
              rating: const Value(4.5),
              thumbnailUrl: const Value('thumb'),
              coverImage: const Value('old-cover'),
              createdAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.module)
          .insert(
            ModuleCompanion.insert(
              id: const Value(100),
              courseId: 1,
              title: 'Keep',
              description: 'Keep module',
              orderIndex: 0,
              createdAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.module)
          .insert(
            ModuleCompanion.insert(
              id: const Value(101),
              courseId: 1,
              title: 'Remove',
              description: 'Remove module',
              orderIndex: 1,
              createdAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.lesson)
          .insert(
            LessonCompanion.insert(
              id: const Value(10),
              moduleId: 100,
              title: 'Keep lesson',
              contentText: 'Content',
              videoUrl: const Value(null),
              imageUrls: const Value(null),
              orderIndex: 0,
              durationMinutes: 5,
              createdAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.lesson)
          .insert(
            LessonCompanion.insert(
              id: const Value(11),
              moduleId: 101,
              title: 'Remove lesson',
              contentText: 'Content',
              videoUrl: const Value(null),
              imageUrls: const Value(null),
              orderIndex: 0,
              durationMinutes: 5,
              createdAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.task)
          .insert(
            TaskCompanion.insert(
              id: const Value(1),
              lessonId: 10,
              taskType: TaskType.textInput,
              questionText: 'Keep task',
              correctAnswer: 'A',
              optionsJson: const Value(null),
              codeTemplate: const Value(null),
              testCasesJson: const Value(null),
              programmingLanguage: const Value(null),
              difficultyLevel: 1,
              xpValue: 10,
              orderIndex: 0,
              fallbackHint: const Value(null),
              fallbackExplanation: const Value(null),
              topic: 'Topic',
              createdAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.task)
          .insert(
            TaskCompanion.insert(
              id: const Value(2),
              lessonId: 11,
              taskType: TaskType.textInput,
              questionText: 'Remove task',
              correctAnswer: 'B',
              optionsJson: const Value(null),
              codeTemplate: const Value(null),
              testCasesJson: const Value(null),
              programmingLanguage: const Value(null),
              difficultyLevel: 1,
              xpValue: 10,
              orderIndex: 0,
              fallbackHint: const Value(null),
              fallbackExplanation: const Value(null),
              topic: 'Topic',
              createdAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.lessonProgress)
          .insert(
            LessonProgressCompanion.insert(
              lessonId: 10,
              userId: 'user-1',
              isCompleted: const Value(true),
              completedAt: const Value(null),
              timeSpentSeconds: const Value(120),
            ),
          );
      await database
          .into(database.lessonProgress)
          .insert(
            LessonProgressCompanion.insert(
              lessonId: 11,
              userId: 'user-1',
              isCompleted: const Value(true),
              completedAt: const Value(null),
              timeSpentSeconds: const Value(240),
            ),
          );
      await database
          .into(database.taskProgress)
          .insert(
            TaskProgressCompanion.insert(
              taskId: 1,
              userId: 'user-1',
              isCompleted: const Value(true),
              attempts: const Value(1),
              hintsUsed: const Value(0),
              xpEarned: const Value(10),
              userAnswer: const Value('A'),
              completedAt: const Value(null),
              lastAttemptAt: DateTime(2026, 3, 9),
            ),
          );
      await database
          .into(database.taskProgress)
          .insert(
            TaskProgressCompanion.insert(
              taskId: 2,
              userId: 'user-1',
              isCompleted: const Value(true),
              attempts: const Value(1),
              hintsUsed: const Value(0),
              xpEarned: const Value(10),
              userAnswer: const Value('B'),
              completedAt: const Value(null),
              lastAttemptAt: DateTime(2026, 3, 9),
            ),
          );

      await dataSource.replaceCourseDetailSnapshot(_courseDetailDto);

      final course = await dataSource.getCourseById(1);
      final modules = await database.managers.module
          .filter((f) => f.courseId.id(1))
          .get();
      final lessons = await database.managers.lesson.get();
      final tasks = await database.managers.task.get();
      final lessonProgress = await database.managers.lessonProgress.get();
      final taskProgress = await database.managers.taskProgress.get();

      expect(course, isNotNull);
      expect(course!.coverImage, 'new-cover');
      expect(modules.map((module) => module.id), [100]);
      expect(lessons.map((lesson) => lesson.id), [10]);
      expect(tasks.map((task) => task.id), [1]);
      expect(lessonProgress.map((progress) => progress.lessonId), [10]);
      expect(taskProgress.map((progress) => progress.taskId), [1]);
    },
  );
}

final _courseDetailDto = client.CourseDetailDto(
  course: client.CourseDto(
    id: 1,
    title: 'Course',
    description: 'Updated description',
    author: 'Author',
    category: 'Category',
    difficultyLevel: 'beginner',
    priceInCoins: 100,
    durationMinutes: 60,
    rating: 4.5,
    thumbnailUrl: 'thumb',
    coverImage: 'new-cover',
    createdAt: DateTime(2026, 3, 9),
    updatedAt: DateTime(2026, 3, 9),
    contentStatus: client.ContentStatus.published,
    publishedAt: DateTime(2026, 3, 9),
    totalLessons: 1,
    totalTasks: 1,
  ),
  modules: [
    client.ModuleDto(
      id: 100,
      courseId: 1,
      title: 'Keep',
      description: 'Keep module updated',
      orderIndex: 0,
      createdAt: DateTime(2026, 3, 9),
      updatedAt: DateTime(2026, 3, 9),
    ),
  ],
  lessons: [
    client.LessonDto(
      id: 10,
      moduleId: 100,
      title: 'Keep lesson',
      contentText: 'Updated content',
      contentDocument: null,
      videoUrl: null,
      imageUrls: null,
      orderIndex: 0,
      durationMinutes: 5,
      completionXp: 5,
      createdAt: DateTime(2026, 3, 9),
      updatedAt: DateTime(2026, 3, 9),
    ),
  ],
  tasks: [
    client.TaskDto(
      id: 1,
      lessonId: 10,
      taskType: client.TaskType.textInput,
      questionText: 'Keep task',
      correctAnswer: 'A',
      optionsJson: null,
      codeTemplate: null,
      testCasesJson: null,
      programmingLanguage: null,
      difficultyLevel: 1,
      xpValue: 10,
      orderIndex: 0,
      fallbackHint: null,
      fallbackExplanation: null,
      topic: 'Topic',
      createdAt: DateTime(2026, 3, 9),
      updatedAt: DateTime(2026, 3, 9),
      options: const [],
      testCases: const [],
    ),
  ],
);
