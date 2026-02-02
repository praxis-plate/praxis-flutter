import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';

abstract interface class IUserStatisticsRepository {
  Future<Result<UserStatisticModel?>> getByUserId(String userId);
}
