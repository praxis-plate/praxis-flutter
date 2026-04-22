import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/remote/user_statistics_remote_datasource.dart';
import 'package:praxis/data/entities/user_statistics_dto_extension.dart';
import 'package:praxis/domain/models/user/user_statistic_model.dart';
import 'package:praxis/domain/repositories/i_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UserStatisticsRepository implements IUserStatisticsRepository {
  final UserStatisticsRemoteDataSource _remoteDataSource;

  const UserStatisticsRepository(this._remoteDataSource);

  @override
  Future<Result<UserStatisticModel?>> getByUserId(String userId) async {
    try {
      final userStatsDto = await _remoteDataSource.getUserStatistics();
      return Success(userStatsDto.toDomain());
    } on AppError catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      return Failure(AppFailure.fromError(e));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      return Failure(AppFailure.fromException(e));
    }
  }
}
