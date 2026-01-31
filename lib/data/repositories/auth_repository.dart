import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/auth_session_entity.dart';
import 'package:codium/data/entities/auth_session_entity_extension.dart';
import 'package:codium/data/mappers/exceptions/auth_exception_mapper.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/i_auth_repository.dart';
import 'package:codium/domain/services/services.dart';
import 'package:codium/data/datasources/remote/auth_session_remote_datasource.dart';

final class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;
  final ISessionService _sessionService;
  final AuthSessionRemoteDataSource _authSessionRemoteDataSource;

  AuthRepository(
    this._authDataSource,
    this._sessionService,
    this._authSessionRemoteDataSource,
  );

  @override
  Future<Result<String>> startRegistration(String email) async {
    try {
      final requestId = await _authDataSource.startRegistration(email: email);
      return Success(requestId);
    } catch (e) {
      return Failure(AuthExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<String>> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  }) async {
    try {
      final token = await _authDataSource.verifyRegistrationCode(
        accountRequestId: accountRequestId,
        verificationCode: verificationCode,
      );
      return Success(token);
    } catch (e) {
      return Failure(AuthExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<UserProfileModel>> signUp({
    required String email,
    required String password,
    required String registrationToken,
  }) async {
    try {
      final session = await _authDataSource.finishRegistration(
        email: email,
        password: password,
        registrationToken: registrationToken,
      );
      await _saveSession(session);
      await _updateClientAuthSession(session);
      return Success(session.toUserProfileModel());
    } catch (e) {
      return Failure(AuthExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<UserProfileModel>> signIn(String email, String password) async {
    try {
      final session = await _authDataSource.login(
        email: email,
        password: password,
      );
      await _saveSession(session);
      await _updateClientAuthSession(session);
      return Success(session.toUserProfileModel());
    } catch (e) {
      return Failure(AuthExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<String>> startPasswordReset(String email) async {
    try {
      final requestId = await _authDataSource.startPasswordReset(email: email);
      return Success(requestId);
    } catch (e) {
      return Failure(AuthExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<String>> verifyPasswordResetCode({
    required String passwordResetRequestId,
    required String verificationCode,
  }) async {
    try {
      final token = await _authDataSource.verifyPasswordResetCode(
        passwordResetRequestId: passwordResetRequestId,
        verificationCode: verificationCode,
      );
      return Success(token);
    } catch (e) {
      return Failure(AuthExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    try {
      await _authDataSource.finishPasswordReset(
        finishPasswordResetToken: finishPasswordResetToken,
        newPassword: newPassword,
      );
      return const Success(null);
    } catch (e) {
      return Failure(AuthExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _authSessionRemoteDataSource.clear();
      await _sessionService.clearSession();
      return const Success(null);
    } catch (e) {
      return Failure(
        AppFailure.fromException(e is Exception ? e : Exception(e.toString())),
      );
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      final hasLocalSession = await _sessionService.hasActiveSession();
      return Success(hasLocalSession);
    } catch (e) {
      return Failure(
        AppFailure.fromException(e is Exception ? e : Exception(e.toString())),
      );
    }
  }

  Future<void> _saveSession(AuthSessionEntity session) async {
    await _sessionService.saveSession(session.toSessionModel());
  }

  Future<void> _updateClientAuthSession(AuthSessionEntity session) async {
    await _authSessionRemoteDataSource.update(session);
  }
}
