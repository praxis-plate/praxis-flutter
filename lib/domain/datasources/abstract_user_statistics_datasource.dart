import 'package:codium/domain/models/models.dart';

abstract interface class IUserStatisticsDataSource {
  Future<UserStatistics> fetchStatisticsByUserId(String id);
  Future<void> uploadStatistics(UserStatistics statistics);
}