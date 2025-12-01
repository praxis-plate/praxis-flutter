import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/user_entity_extension.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';
import 'package:codium/domain/services/services.dart';

final class AuthRepository implements IAuthRepository {
  final IUserDataSource _userDataSource;
  final ISessionService _sessionService;

  AuthRepository(this._userDataSource, this._sessionService);

  @override
  Future<Result<UserProfileModel>> signUp(String email, String password) async {
    try {
      final existingUser = await _userDataSource.getUserByEmail(email);

      if (existingUser != null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.validationInvalid,
            message: 'User with this email is already registered',
            canRetry: false,
          ),
        );
      }

      final user = await _userDataSource.create(
        email: email,
        password: password,
      );

      if (user == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.databaseGeneral,
            message: 'Failed to create user',
            canRetry: true,
          ),
        );
      }

      await _sessionService.saveSession(userId: user.id, email: email);
      return Success(user.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<UserProfileModel>> signIn(String email, String password) async {
    try {
      final user = await _userDataSource.getUserByEmail(email);

      if (user == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: 'User with this email is not found',
            canRetry: false,
          ),
        );
      }

      if (user.passwordHash != _userDataSource.hashPassword(password)) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiUnauthorized,
            message: 'Invalid email or password',
            canRetry: false,
          ),
        );
      }

      await _sessionService.saveSession(userId: user.id, email: user.email);
      return Success(user.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _sessionService.clearSession();
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      final isAuth = await _sessionService.hasActiveSession();
      return Success(isAuth);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
