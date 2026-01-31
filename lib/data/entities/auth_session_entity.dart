import 'package:serverpod_client/serverpod_client.dart';

class AuthSessionEntity {
  final String authStrategy;
  final UuidValue authUserId;
  final String accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiresAt;
  final String email;
  final Set<String> scopeNames;

  const AuthSessionEntity({
    required this.authStrategy,
    required this.authUserId,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpiresAt,
    required this.email,
    required this.scopeNames,
  });
}
