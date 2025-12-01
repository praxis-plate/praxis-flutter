import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/user_statistic_entity_extension.dart';
import 'package:codium/domain/datasources/i_user_statistics_local_datasource.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';
import 'package:codium/domain/models/user_statistic/create_user_statistic_model.dart';
import 'package:codium/domain/models/user_statistic/update_user_statistic_model.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';

class UserStatisticsRepository implements IUserStatisticsRepository {
  final IUserStatisticsLocalDataSource _localDataSource;

  const UserStatisticsRepository(this._localDataSource);

  @override
  Future<Result<UserStatisticModel?>> getByUserId(int userId) async {
    try {
      final entity = await _localDataSource.getStatisticsByUserId(userId);
      return Success(entity?.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> create(CreateUserStatisticModel model) async {
    try {
      await _localDataSource.insertStatistics(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> update(UpdateUserStatisticModel model) async {
    try {
      await _localDataSource.updateStatistics(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> delete(int userId) async {
    try {
      await _localDataSource.deleteStatistics(userId);
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
