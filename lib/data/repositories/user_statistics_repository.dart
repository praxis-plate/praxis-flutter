import 'package:codium/core/exceptions/user_statistics_exception.dart';
import 'package:codium/domain/datasources/abstract_user_statistics_datasource.dart';
import 'package:codium/domain/datasources/abstract_user_statistics_local_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';

class UserStatisticsRepository implements IUserStatisticsRepository {
  final IUserStatisticsLocalDataSource _localDataSource;
  final IUserStatisticsDataSource _remoteDataSource;

  UserStatisticsRepository({
    required IUserStatisticsLocalDataSource localDataSource,
    required IUserStatisticsDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<UserCourseStatistics> createUserCourseStatistics({
    required String userId,
    required String courseId,
  }) async {
    try {
      final stats = await _localDataSource.getStatistics(userId);

      if (stats != null && stats.courses.containsKey(courseId)) {
        return stats.courses[courseId]!;
      }

      final newCourseStats = UserCourseStatistics(
        courseId: courseId,
        progress: 0,
        totalTasks: 0,
        solvedTasks: 0,
        timeSpent: Duration.zero,
        lastActivity: DateTime.now(),
      );

      final updatedStats =
          stats?.copyWith(
            courses: {...stats.courses, courseId: newCourseStats},
          ) ??
          UserStatistics(
            userId: userId,
            courses: {courseId: newCourseStats},
            currentStreak: 0,
            maxStreak: 0,
            points: 0,
            lastActiveDate: DateTime.now(),
          );

      await _localDataSource.saveStatistics(updatedStats);
      return newCourseStats;
    } catch (e) {
      throw UserStatisticsException(
        'Failed to create course statistics: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> exists(String userId) async {
    try {
      final stats = await _localDataSource.getStatistics(userId);
      return stats != null;
    } catch (e) {
      throw UserStatisticsException(
        'Failed to check statistics existence: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserStatistics> get(String userId) async {
    try {
      final localStats = await _localDataSource.getStatistics(userId);
      if (localStats != null) {
        return localStats;
      }

      try {
        final remoteStats = await _remoteDataSource.fetchStatisticsByUserId(
          userId,
        );
        await _localDataSource.saveStatistics(remoteStats);
        return remoteStats;
      } catch (remoteError) {
        final newStats = UserStatistics(
          userId: userId,
          courses: {},
          currentStreak: 0,
          maxStreak: 0,
          points: 0,
          lastActiveDate: DateTime.now(),
        );
        await _localDataSource.saveStatistics(newStats);
        return newStats;
      }
    } catch (e) {
      throw UserStatisticsException(
        'Ошибка загрузки статистики: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserCourseStatistics> getUserCourseStatistics({
    required String userId,
    required String courseId,
  }) async {
    try {
      final stats = await _localDataSource.getStatistics(userId);

      if (stats == null || !stats.courses.containsKey(courseId)) {
        throw UserStatisticsException('Course statistics not found');
      }

      return stats.courses[courseId]!;
    } on UserStatisticsException {
      rethrow;
    } catch (e) {
      throw UserStatisticsException(
        'Failed to get course statistics: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> reset(String userId) async {
    try {
      await _localDataSource.clearStatistics(userId);
    } catch (e) {
      throw UserStatisticsException(
        'Failed to reset statistics: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> update(UserStatistics stats) async {
    try {
      await _localDataSource.saveStatistics(stats);
    } catch (e) {
      throw UserStatisticsException(
        'Failed to update statistics: ${e.toString()}',
      );
    }
  }
}
