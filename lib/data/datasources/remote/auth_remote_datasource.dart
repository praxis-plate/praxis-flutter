import 'package:codium/data/entities/auth_session_entity.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:praxis_client/praxis_client.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Client _client;

  const AuthRemoteDataSource(this._client);

  @override
  Future<String> startRegistration({required String email}) async {
    final requestId = await _client.emailIdp.startRegistration(email: email);
    return requestId.toString();
  }

  @override
  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  }) async {
    return _client.emailIdp.verifyRegistrationCode(
      accountRequestId: UuidValue.fromString(accountRequestId),
      verificationCode: verificationCode,
    );
  }

  @override
  Future<AuthSessionEntity> finishRegistration({
    required String email,
    required String password,
    required String registrationToken,
  }) async {
    final authSuccess = await _client.emailIdp.finishRegistration(
      registrationToken: registrationToken,
      password: password,
    );

    return AuthSessionEntity(
      authUserId: authSuccess.authUserId,
      accessToken: authSuccess.token,
      refreshToken: authSuccess.refreshToken,
      tokenExpiresAt: authSuccess.tokenExpiresAt,
      email: email,
    );
  }

  @override
  Future<AuthSessionEntity> login({
    required String email,
    required String password,
  }) async {
    final authSuccess = await _client.emailIdp.login(
      email: email,
      password: password,
    );

    return AuthSessionEntity(
      authUserId: authSuccess.authUserId,
      accessToken: authSuccess.token,
      refreshToken: authSuccess.refreshToken,
      tokenExpiresAt: authSuccess.tokenExpiresAt,
      email: email,
    );
  }

  @override
  Future<String> startPasswordReset({required String email}) async {
    final requestId = await _client.emailIdp.startPasswordReset(email: email);
    return requestId.toString();
  }

  @override
  Future<String> verifyPasswordResetCode({
    required String passwordResetRequestId,
    required String verificationCode,
  }) async {
    return _client.emailIdp.verifyPasswordResetCode(
      passwordResetRequestId: UuidValue.fromString(passwordResetRequestId),
      verificationCode: verificationCode,
    );
  }

  @override
  Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    await _client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: newPassword,
    );
  }
}
