import 'package:codium/domain/models/models.dart';

abstract interface class IUserStatisticsDataSource {
  Future<UserStatisticModel> fetchStatisticsByUserId(String id);
  Future<void> uploadStatistics(UserStatisticModel statistics);
}
