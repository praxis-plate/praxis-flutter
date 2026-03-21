import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/local/user_local_datasource.dart';
import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/entities/user_entity_extension.dart';
import 'package:praxis/domain/models/user/user.dart';
import 'package:praxis/domain/repositories/i_user_repository.dart';
import 'package:praxis/domain/services/services.dart';

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

      final user = await _getOrCreateCurrentUser(session.userId, session.email);
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
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<UserProfileModel>> getUserById(String userId) async {
    try {
      UserEntity? user = await _userDataSource.getUserById(userId);
      if (user == null) {
        final session = await _sessionService.getSession();
        if (session?.userId == userId) {
          user = await _getOrCreateCurrentUser(session!.userId, session.email);
        }
      }

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
      return Failure(AppFailure.fromException(e));
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
      return Failure(AppFailure.fromException(e));
    }
  }

  Future<UserEntity?> _getOrCreateCurrentUser(
    String userId,
    String email,
  ) async {
    final existingUser = await _userDataSource.getUserById(userId);
    if (existingUser != null) {
      return existingUser;
    }

    return _userDataSource.upsertFromSession(userId: userId, email: email);
  }
}
