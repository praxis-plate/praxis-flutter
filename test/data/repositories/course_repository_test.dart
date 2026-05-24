import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/exceptions/app_exception.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/datasources/local/course_local_datasource.dart';
import 'package:praxis/data/datasources/local/lesson_local_datasource.dart';
import 'package:praxis/data/datasources/local/module_local_datasource.dart';
import 'package:praxis/data/datasources/local/task_local_datasource.dart';
import 'package:praxis/data/datasources/remote/course_remote_datasource.dart';
import 'package:praxis/data/repositories/course_repository.dart';
import 'package:praxis/domain/enums/task_type.dart';
import 'package:praxis_client/praxis_client.dart' hide TaskType;

class _MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

class _MockCourseLocalDataSource extends Mock
    implements CourseLocalDataSource {}

class _MockModuleLocalDataSource extends Mock
    implements ModuleLocalDataSource {}

class _MockLessonLocalDataSource extends Mock
    implements LessonLocalDataSource {}

class _MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

void main() {
  late CourseRepository repository;
  late _MockCourseRemoteDataSource remoteDataSource;
  late _MockCourseLocalDataSource courseLocalDataSource;
  late _MockModuleLocalDataSource moduleLocalDataSource;
  late _MockLessonLocalDataSource lessonLocalDataSource;
  late _MockTaskLocalDataSource taskLocalDataSource;

  setUp(() {
    remoteDataSource = _MockCourseRemoteDataSource();
    courseLocalDataSource = _MockCourseLocalDataSource();
    moduleLocalDataSource = _MockModuleLocalDataSource();
    lessonLocalDataSource = _MockLessonLocalDataSource();
    taskLocalDataSource = _MockTaskLocalDataSource();

    repository = CourseRepository(
      remoteDataSource,
      courseLocalDataSource,
      moduleLocalDataSource,
      lessonLocalDataSource,
      taskLocalDataSource,
    );
  });

  test('getCourseById falls back to cached course when remote fails', () async {
    when(
      () => courseLocalDataSource.getCourseById(1),
    ).thenAnswer((_) async => _courseEntity);
    when(
      () => lessonLocalDataSource.getLessonsByCourseId(1),
    ).thenAnswer((_) async => [_lessonEntity]);
    when(
      () => taskLocalDataSource.getTasksByLessonId(10),
    ).thenAnswer((_) async => [_taskEntity, _secondTaskEntity]);
    when(
      () => remoteDataSource.getCourseById(1),
    ).thenThrow(const NetworkError.noConnection());

    final result = await repository.getCourseById(1);

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull?.id, 1);
    expect(result.dataOrNull?.totalTasks, 2);
    verify(() => remoteDataSource.getCourseById(1)).called(1);
  });

  test(
    'getTableOfContents falls back to cached structure when remote fails',
    () async {
      when(
        () => courseLocalDataSource.getCourseById(1),
      ).thenAnswer((_) async => _courseEntity);
      when(
        () => moduleLocalDataSource.getModulesByCourseId(1),
      ).thenAnswer((_) async => [_moduleEntity]);
      when(
        () => lessonLocalDataSource.getLessonsByModuleId(100),
      ).thenAnswer((_) async => [_lessonEntity]);
      when(
        () => remoteDataSource.getTableOfContents(1),
      ).thenThrow(const NetworkError.noConnection());

      final result = await repository.getTableOfContents(1);

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.courseId, 1);
      expect(result.dataOrNull?.modules, hasLength(1));
      expect(result.dataOrNull?.modules.first.lessons, hasLength(1));
      verify(() => remoteDataSource.getTableOfContents(1)).called(1);
    },
  );

  test(
    'getCourseById returns failure for not found even when cache exists',
    () async {
      when(
        () => courseLocalDataSource.getCourseById(1),
      ).thenAnswer((_) async => _courseEntity);
      when(
        () => remoteDataSource.getCourseById(1),
      ).thenAnswer((_) async => null);

      final result = await repository.getCourseById(1);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.code, AppErrorCode.apiNotFound);
    },
  );

  test(
    'getTableOfContents returns failure for forbidden even when cache exists',
    () async {
      when(
        () => courseLocalDataSource.getCourseById(1),
      ).thenAnswer((_) async => _courseEntity);
      when(
        () => moduleLocalDataSource.getModulesByCourseId(1),
      ).thenAnswer((_) async => [_moduleEntity]);
      when(
        () => lessonLocalDataSource.getLessonsByModuleId(100),
      ).thenAnswer((_) async => [_lessonEntity]);
      when(
        () => remoteDataSource.getTableOfContents(1),
      ).thenThrow(const ApiError.forbidden());

      final result = await repository.getTableOfContents(1);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.code, AppErrorCode.apiForbidden);
    },
  );

  test(
    'getCourseById uses remote totalTasks after successful refresh',
    () async {
      when(
        () => courseLocalDataSource.getCourseById(1),
      ).thenAnswer((_) async => _courseEntity);
      when(
        () => remoteDataSource.getCourseById(1),
      ).thenAnswer((_) async => _courseDetailDto);
      when(
        () =>
            courseLocalDataSource.replaceCourseDetailSnapshot(_courseDetailDto),
      ).thenAnswer((_) async {});

      final result = await repository.getCourseById(1);

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.totalTasks, 1);
      expect(result.dataOrNull?.coverImage, 'cover');
    },
  );
}

final _courseEntity = CourseEntity(
  id: 1,
  title: 'Course',
  description: 'Description',
  author: 'Author',
  category: 'Category',
  priceInCoins: 100,
  durationMinutes: 60,
  rating: 4.5,
  thumbnailUrl: 'thumb',
  coverImage: 'thumb',
  createdAt: DateTime(2026, 3, 9),
);

final _moduleEntity = ModuleEntity(
  id: 100,
  courseId: 1,
  title: 'Module',
  description: 'Basics',
  orderIndex: 0,
  createdAt: DateTime(2026, 3, 9),
);

final _lessonEntity = LessonEntity(
  id: 10,
  moduleId: 100,
  title: 'Lesson',
  contentText: 'Content',
  videoUrl: null,
  imageUrls: null,
  orderIndex: 0,
  durationMinutes: 5,
  createdAt: DateTime(2026, 3, 9),
);

final _taskEntity = TaskEntity(
  id: 1,
  lessonId: 10,
  taskType: TaskType.textInput,
  questionText: 'Question',
  correctAnswer: 'Answer',
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
);

final _secondTaskEntity = TaskEntity(
  id: 2,
  lessonId: 10,
  taskType: TaskType.textInput,
  questionText: 'Question 2',
  correctAnswer: 'Answer 2',
  optionsJson: null,
  codeTemplate: null,
  testCasesJson: null,
  programmingLanguage: null,
  difficultyLevel: 1,
  xpValue: 10,
  orderIndex: 1,
  fallbackHint: null,
  fallbackExplanation: null,
  topic: 'Topic',
  createdAt: DateTime(2026, 3, 9),
);

final _courseDetailDto = CourseDetailDto(
  course: CourseDto(
    id: 1,
    title: 'Course',
    description: 'Description',
    author: 'Author',
    category: 'Category',
    difficultyLevel: 'beginner',
    priceInCoins: 100,
    durationMinutes: 60,
    rating: 4.5,
    thumbnailUrl: 'thumb',
    coverImage: 'cover',
    createdAt: DateTime(2026, 3, 9),
    updatedAt: DateTime(2026, 3, 9),
    contentStatus: ContentStatus.published,
    publishedAt: DateTime(2026, 3, 9),
    totalLessons: 1,
    totalTasks: 1,
  ),
  modules: const [],
  lessons: const [],
  tasks: const [],
);
