import 'package:codium/data/entities/auth_session_entity.dart';
import 'package:codium/domain/models/auth/auth_session_model.dart';

extension AuthSessionEntityMapper on AuthSessionEntity {
  AuthSessionModel toDomain() {
    return AuthSessionModel(
      userId: authUserId.toString(),
      accessToken: accessToken,
      refreshToken: refreshToken ?? '',
      expiresAt: tokenExpiresAt ?? DateTime.now().add(const Duration(hours: 1)),
    );
  }
}
