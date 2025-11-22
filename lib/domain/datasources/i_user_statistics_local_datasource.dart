import 'package:codium/domain/models/models.dart';

abstract interface class IUserStatisticsLocalDataSource {
  Future<UserStatistics?> getStatistics(String userId);
  Future<void> saveStatistics(UserStatistics statistics);
  Future<void> clearStatistics(String userId);
}