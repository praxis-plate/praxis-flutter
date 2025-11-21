import 'package:codium/domain/datasources/abstract_user_statistics_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/mocs/data/mock_user_statistics.dart';

class UserStatisticsRemoteDataSource implements IUserStatisticsDataSource {
  @override
  Future<UserStatistics> fetchStatisticsByUserId(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockUserStatistics;
  }

  @override
  Future<void> uploadStatistics(UserStatistics statistics) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
