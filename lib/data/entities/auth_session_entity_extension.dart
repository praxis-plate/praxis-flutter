import 'package:codium/data/entities/auth_session_entity.dart';
import 'package:codium/domain/models/session/session_model.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:serverpod_client/serverpod_client.dart';

extension AuthSessionEntityExtension on AuthSessionEntity {
  SessionModel toSessionModel() {
    return SessionModel(
      userId: _authUserIdToLocalId(authUserId),
      email: email,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: tokenExpiresAt,
    );
  }

  UserProfileModel toUserProfileModel() {
    return UserProfileModel(
      id: _authUserIdToLocalId(authUserId),
      email: email,
      name: email.split('@').first,
      createdAt: DateTime.now(),
    );
  }
}

int _authUserIdToLocalId(UuidValue authUserId) {
  return authUserId.uuid.hashCode;
}
