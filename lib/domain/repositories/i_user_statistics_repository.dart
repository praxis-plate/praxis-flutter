import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';
import 'package:codium/domain/models/user_statistic/create_user_statistic_model.dart';
import 'package:codium/domain/models/user_statistic/update_user_statistic_model.dart';

abstract interface class IUserStatisticsRepository {
  Future<Result<UserStatisticModel?>> getByUserId(int userId);
  Future<Result<void>> create(CreateUserStatisticModel model);
  Future<Result<void>> update(UpdateUserStatisticModel model);
  Future<Result<void>> delete(int userId);
}
