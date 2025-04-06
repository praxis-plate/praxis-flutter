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
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<UserStatistics> getStatisticsByUserId(String userId) async {
    try {
      final remoteStats = await _remoteDataSource.fetchStatisticsByUserId(userId);
      await _localDataSource.saveStatistics(remoteStats);
      return remoteStats;
    } catch (e) {
      throw UserStatisticsException('Ошибка загрузки статистики');
    }
  }
  
  @override
  Future<Course> getCourseStatistics(String userId, String courseId) {
    // TODO: implement getCourseStatistics
    throw UnimplementedError();
  }
}
