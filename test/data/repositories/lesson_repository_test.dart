import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/exceptions/app_exception.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/datasources/local/lesson_local_datasource.dart';
import 'package:praxis/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:praxis/data/repositories/lesson_repository.dart';

class _MockLessonRemoteDataSource extends Mock
    implements LessonRemoteDataSource {}

class _MockLessonLocalDataSource extends Mock
    implements LessonLocalDataSource {}

void main() {
  late LessonRepository repository;
  late _MockLessonRemoteDataSource remoteDataSource;
  late _MockLessonLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = _MockLessonRemoteDataSource();
    localDataSource = _MockLessonLocalDataSource();
    repository = LessonRepository(remoteDataSource, localDataSource);
  });

  test(
    'getLessonsByCourseId falls back to cached lessons on remote error',
    () async {
      when(
        () => localDataSource.getLessonsByCourseId(1),
      ).thenAnswer((_) async => [_lessonEntity]);
      when(
        () => remoteDataSource.getLessonsByCourseId(1),
      ).thenThrow(const NetworkError.noConnection());

      final result = await repository.getLessonsByCourseId(1);

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, hasLength(1));
      verify(() => remoteDataSource.getLessonsByCourseId(1)).called(1);
    },
  );

  test('getLessonById falls back to cached lesson on remote error', () async {
    when(
      () => localDataSource.getLessonById(10),
    ).thenAnswer((_) async => _lessonEntity);
    when(
      () => remoteDataSource.getLessonById(10),
    ).thenThrow(const NetworkError.noConnection());

    final result = await repository.getLessonById(10);

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull?.id, 10);
    verify(() => remoteDataSource.getLessonById(10)).called(1);
  });

  test(
    'getLessonById returns failure for forbidden even when cache exists',
    () async {
      when(
        () => localDataSource.getLessonById(10),
      ).thenAnswer((_) async => _lessonEntity);
      when(
        () => remoteDataSource.getLessonById(10),
      ).thenThrow(const ApiError.forbidden());

      final result = await repository.getLessonById(10);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.code, AppErrorCode.apiForbidden);
    },
  );
}

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
