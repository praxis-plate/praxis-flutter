import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/exceptions/app_exception.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/datasources/local/task_local_datasource.dart';
import 'package:praxis/data/datasources/remote/task_remote_datasource.dart';
import 'package:praxis/data/repositories/task_repository.dart';
import 'package:praxis/domain/enums/task_type.dart';

class _MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class _MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

void main() {
  late TaskRepository repository;
  late _MockTaskRemoteDataSource remoteDataSource;
  late _MockTaskLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = _MockTaskRemoteDataSource();
    localDataSource = _MockTaskLocalDataSource();
    repository = TaskRepository(remoteDataSource, localDataSource);
  });

  test('getTaskById falls back to cached task on remote error', () async {
    when(
      () => localDataSource.getTaskById(1),
    ).thenAnswer((_) async => _taskEntity);
    when(
      () => remoteDataSource.getTaskById(1),
    ).thenThrow(const NetworkError.noConnection());

    final result = await repository.getTaskById(1);

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull?.id, 1);
    verify(() => remoteDataSource.getTaskById(1)).called(1);
  });

  test(
    'getTaskById returns failure for not found even when cache exists',
    () async {
      when(
        () => localDataSource.getTaskById(1),
      ).thenAnswer((_) async => _taskEntity);
      when(
        () => remoteDataSource.getTaskById(1),
      ).thenThrow(const ApiError.notFound());

      final result = await repository.getTaskById(1);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.code, AppErrorCode.apiNotFound);
    },
  );
}

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
