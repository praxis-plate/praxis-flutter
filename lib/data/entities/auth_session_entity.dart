import 'package:serverpod_client/serverpod_client.dart';

class AuthSessionEntity {
  final UuidValue authUserId;
  final String accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiresAt;
  final String email;

  const AuthSessionEntity({
    required this.authUserId,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpiresAt,
    required this.email,
  });
}
