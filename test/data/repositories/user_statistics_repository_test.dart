import 'package:codium/core/exceptions/user_statistics_exception.dart';
import 'package:codium/data/repositories/user_statistics_repository.dart';
import 'package:codium/domain/datasources/abstract_user_statistics_datasource.dart';
import 'package:codium/domain/datasources/abstract_user_statistics_local_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserStatisticsLocalDataSource extends Mock
    implements IUserStatisticsLocalDataSource {}

class MockUserStatisticsDataSource extends Mock
    implements IUserStatisticsDataSource {}

class FakeUserStatistics extends Fake implements UserStatistics {}

void main() {
  late UserStatisticsRepository repository;
  late MockUserStatisticsLocalDataSource mockLocalDataSource;
  late MockUserStatisticsDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeUserStatistics());
  });

  setUp(() {
    mockLocalDataSource = MockUserStatisticsLocalDataSource();
    mockRemoteDataSource = MockUserStatisticsDataSource();
    repository = UserStatisticsRepository(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('UserStatisticsRepository', () {
    const testUserId = 'test-user-id';
    const testCourseId = 'test-course-id';

    final testStats = UserStatistics(
      userId: testUserId,
      courses: {},
      currentStreak: 5,
      maxStreak: 10,
      points: 100,
      lastActiveDate: DateTime(2024, 1, 1),
    );

    final testCourseStats = UserCourseStatistics(
      courseId: testCourseId,
      progress: 0.5,
      totalTasks: 10,
      solvedTasks: 5,
      timeSpent: const Duration(hours: 2),
      lastActivity: DateTime(2024, 1, 1),
    );

    group('exists', () {
      test('returns true when statistics exist', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => testStats);

        final result = await repository.exists(testUserId);

        expect(result, true);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
      });

      test('returns false when statistics do not exist', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => null);

        final result = await repository.exists(testUserId);

        expect(result, false);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
      });

      test('throws UserStatisticsException on error', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenThrow(Exception('Database error'));

        expect(
          () => repository.exists(testUserId),
          throwsA(isA<UserStatisticsException>()),
        );
      });
    });

    group('get', () {
      test('returns local statistics when available', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => testStats);

        final result = await repository.get(testUserId);

        expect(result, testStats);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
        verifyNever(
          () => mockRemoteDataSource.fetchStatisticsByUserId(testUserId),
        );
      });

      test(
        'fetches and saves remote statistics when local not available',
        () async {
          when(
            () => mockLocalDataSource.getStatistics(testUserId),
          ).thenAnswer((_) async => null);
          when(
            () => mockRemoteDataSource.fetchStatisticsByUserId(testUserId),
          ).thenAnswer((_) async => testStats);
          when(
            () => mockLocalDataSource.saveStatistics(testStats),
          ).thenAnswer((_) async {});

          final result = await repository.get(testUserId);

          expect(result, testStats);
          verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
          verify(
            () => mockRemoteDataSource.fetchStatisticsByUserId(testUserId),
          ).called(1);
          verify(() => mockLocalDataSource.saveStatistics(testStats)).called(1);
        },
      );

      test('creates new statistics when remote fetch fails', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => null);
        when(
          () => mockRemoteDataSource.fetchStatisticsByUserId(testUserId),
        ).thenThrow(Exception('Network error'));
        when(
          () => mockLocalDataSource.saveStatistics(any()),
        ).thenAnswer((_) async {});

        final result = await repository.get(testUserId);

        expect(result.userId, testUserId);
        expect(result.courses, isEmpty);
        expect(result.currentStreak, 0);
        expect(result.maxStreak, 0);
        expect(result.points, 0);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
        verify(
          () => mockRemoteDataSource.fetchStatisticsByUserId(testUserId),
        ).called(1);
        verify(() => mockLocalDataSource.saveStatistics(any())).called(1);
      });

      test('throws UserStatisticsException on local error', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenThrow(Exception('Database error'));

        expect(
          () => repository.get(testUserId),
          throwsA(isA<UserStatisticsException>()),
        );
      });
    });

    group('createUserCourseStatistics', () {
      test('returns existing course statistics if available', () async {
        final statsWithCourse = testStats.copyWith(
          courses: {testCourseId: testCourseStats},
        );
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => statsWithCourse);

        final result = await repository.createUserCourseStatistics(
          userId: testUserId,
          courseId: testCourseId,
        );

        expect(result, testCourseStats);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
        verifyNever(() => mockLocalDataSource.saveStatistics(any()));
      });

      test('creates new course statistics for existing user', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => testStats);
        when(
          () => mockLocalDataSource.saveStatistics(any()),
        ).thenAnswer((_) async {});

        final result = await repository.createUserCourseStatistics(
          userId: testUserId,
          courseId: testCourseId,
        );

        expect(result.courseId, testCourseId);
        expect(result.progress, 0);
        expect(result.totalTasks, 0);
        expect(result.solvedTasks, 0);
        expect(result.timeSpent, Duration.zero);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
        verify(() => mockLocalDataSource.saveStatistics(any())).called(1);
      });

      test('creates new user statistics with course for new user', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => null);
        when(
          () => mockLocalDataSource.saveStatistics(any()),
        ).thenAnswer((_) async {});

        final result = await repository.createUserCourseStatistics(
          userId: testUserId,
          courseId: testCourseId,
        );

        expect(result.courseId, testCourseId);
        expect(result.progress, 0);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
        verify(() => mockLocalDataSource.saveStatistics(any())).called(1);
      });

      test('throws UserStatisticsException on error', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenThrow(Exception('Database error'));

        expect(
          () => repository.createUserCourseStatistics(
            userId: testUserId,
            courseId: testCourseId,
          ),
          throwsA(isA<UserStatisticsException>()),
        );
      });
    });

    group('getUserCourseStatistics', () {
      test('returns course statistics when available', () async {
        final statsWithCourse = testStats.copyWith(
          courses: {testCourseId: testCourseStats},
        );
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => statsWithCourse);

        final result = await repository.getUserCourseStatistics(
          userId: testUserId,
          courseId: testCourseId,
        );

        expect(result, testCourseStats);
        verify(() => mockLocalDataSource.getStatistics(testUserId)).called(1);
      });

      test(
        'throws UserStatisticsException when statistics not found',
        () async {
          when(
            () => mockLocalDataSource.getStatistics(testUserId),
          ).thenAnswer((_) async => null);

          expect(
            () => repository.getUserCourseStatistics(
              userId: testUserId,
              courseId: testCourseId,
            ),
            throwsA(isA<UserStatisticsException>()),
          );
        },
      );

      test('throws UserStatisticsException when course not found', () async {
        when(
          () => mockLocalDataSource.getStatistics(testUserId),
        ).thenAnswer((_) async => testStats);

        expect(
          () => repository.getUserCourseStatistics(
            userId: testUserId,
            courseId: testCourseId,
          ),
          throwsA(isA<UserStatisticsException>()),
        );
      });
    });

    group('update', () {
      test('saves statistics successfully', () async {
        when(
          () => mockLocalDataSource.saveStatistics(testStats),
        ).thenAnswer((_) async {});

        await repository.update(testStats);

        verify(() => mockLocalDataSource.saveStatistics(testStats)).called(1);
      });

      test('throws UserStatisticsException on error', () async {
        when(
          () => mockLocalDataSource.saveStatistics(testStats),
        ).thenThrow(Exception('Database error'));

        expect(
          () => repository.update(testStats),
          throwsA(isA<UserStatisticsException>()),
        );
      });
    });

    group('reset', () {
      test('clears statistics successfully', () async {
        when(
          () => mockLocalDataSource.clearStatistics(testUserId),
        ).thenAnswer((_) async {});

        await repository.reset(testUserId);

        verify(() => mockLocalDataSource.clearStatistics(testUserId)).called(1);
      });

      test('throws UserStatisticsException on error', () async {
        when(
          () => mockLocalDataSource.clearStatistics(testUserId),
        ).thenThrow(Exception('Database error'));

        expect(
          () => repository.reset(testUserId),
          throwsA(isA<UserStatisticsException>()),
        );
      });
    });
  });
}
