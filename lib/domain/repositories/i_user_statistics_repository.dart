import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_statistic_model.dart';

abstract interface class IUserStatisticsRepository {
  Future<Result<UserStatisticModel?>> getByUserId(String userId);
}
