import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/datasources/local/user_local_datasource.dart';
import 'package:codium/data/entities/user_entity_extension.dart';
import 'package:codium/domain/models/user/user.dart';
import 'package:codium/domain/repositories/i_user_repository.dart';
import 'package:codium/domain/services/services.dart';

final class UserRepository implements IUserRepository {
  final UserLocalDataSource _userDataSource;
  final ISessionService _sessionService;

  UserRepository(this._userDataSource, this._sessionService);

  @override
  Future<Result<UserProfileModel>> getCurrentUser() async {
    try {
      final session = await _sessionService.getSession();
      if (session == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiUnauthorized,
            message: '',
            canRetry: false,
          ),
        );
      }

      final user = await _userDataSource.getUserById(session.userId);
      if (user == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: '',
            canRetry: false,
          ),
        );
      }

      return Success(user.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<UserProfileModel>> getUserById(String userId) async {
    try {
      final user = await _userDataSource.getUserById(userId);
      if (user == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: '',
            canRetry: false,
          ),
        );
      }

      return Success(user.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> updateUser(UpdateUserProfileModel user) async {
    try {
      await _userDataSource.updateUser(user.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
