import 'package:codium/data/database/app_database.dart';

abstract interface class IUserStatisticsLocalDataSource {
  Future<UserStatisticEntity?> getStatisticsByUserId(int userId);
  Future<UserStatisticEntity> insertStatistics(UserStatisticCompanion entry);
  Future<void> updateStatistics(UserStatisticCompanion entry);
  Future<void> deleteStatistics(int userId);
}
