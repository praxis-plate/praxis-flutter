import 'package:codium/data/entities/auth_session_entity.dart';
import 'package:praxis_client/praxis_client.dart';

class AuthRemoteDataSource {
  final Client _client;

  const AuthRemoteDataSource(this._client);

  Future<String> startRegistration({required String email}) async {
    final requestId = await _client.emailIdp.startRegistration(email: email);
    return requestId.toString();
  }

  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  }) async {
    return _client.emailIdp.verifyRegistrationCode(
      accountRequestId: UuidValue.fromString(accountRequestId),
      verificationCode: verificationCode,
    );
  }

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
      authStrategy: authSuccess.authStrategy,
      authUserId: authSuccess.authUserId,
      accessToken: authSuccess.token,
      refreshToken: authSuccess.refreshToken,
      tokenExpiresAt: authSuccess.tokenExpiresAt,
      email: email,
      scopeNames: authSuccess.scopeNames,
    );
  }

  Future<AuthSessionEntity> login({
    required String email,
    required String password,
  }) async {
    final authSuccess = await _client.emailIdp.login(
      email: email,
      password: password,
    );

    return AuthSessionEntity(
      authStrategy: authSuccess.authStrategy,
      authUserId: authSuccess.authUserId,
      accessToken: authSuccess.token,
      refreshToken: authSuccess.refreshToken,
      tokenExpiresAt: authSuccess.tokenExpiresAt,
      email: email,
      scopeNames: authSuccess.scopeNames,
    );
  }

  Future<String> startPasswordReset({required String email}) async {
    final requestId = await _client.emailIdp.startPasswordReset(email: email);
    return requestId.toString();
  }

  Future<String> verifyPasswordResetCode({
    required String passwordResetRequestId,
    required String verificationCode,
  }) async {
    return _client.emailIdp.verifyPasswordResetCode(
      passwordResetRequestId: UuidValue.fromString(passwordResetRequestId),
      verificationCode: verificationCode,
    );
  }

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
