import 'package:codium/data/entities/auth_session_entity.dart';
import 'package:praxis_client/praxis_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

class AuthSessionRemoteDataSource {
  final Client _client;

  const AuthSessionRemoteDataSource(this._client);

  Future<void> update(AuthSessionEntity session) async {
    final authSuccess = AuthSuccess(
      authStrategy: session.authStrategy,
      token: session.accessToken,
      tokenExpiresAt: session.tokenExpiresAt,
      refreshToken: session.refreshToken,
      authUserId: session.authUserId,
      scopeNames: session.scopeNames,
    );

    await ClientAuthSessionManagerExtension(
      _client,
    ).auth.updateSignedInUser(authSuccess);
  }

  Future<void> clear() async {
    await ClientAuthSessionManagerExtension(
      _client,
    ).auth.updateSignedInUser(null);
  }
}
