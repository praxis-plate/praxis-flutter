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
  Future<bool> exists(String userId) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<UserStatistics> get(String userId) async {
    try {
      final remoteStats = await _remoteDataSource.fetchStatisticsByUserId(
        userId,
      );
      await _localDataSource.saveStatistics(remoteStats);
      return remoteStats;
    } catch (e) {
      throw UserStatisticsException('Ошибка загрузки статистики');
    }
  }

  @override
  Future<UserCourseStatistics> getUserCourseStatistics({
    required String userId,
    required String courseId,
  }) {
    // TODO: implement getUserCourseStatistics
    throw UnimplementedError();
  }

  @override
  Future<void> reset(String userId) {
    // TODO: implement reset
    throw UnimplementedError();
  }

  @override
  Future<void> update(UserStatistics stats) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
