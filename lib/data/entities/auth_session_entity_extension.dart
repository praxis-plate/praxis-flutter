import 'package:praxis/data/entities/auth_session_entity.dart';
import 'package:praxis/domain/models/session/session_model.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';

extension AuthSessionEntityExtension on AuthSessionEntity {
  SessionModel toSessionModel() {
    return SessionModel(
      userId: authUserId.toString(),
      email: email,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: tokenExpiresAt,
    );
  }

  UserProfileModel toUserProfileModel() {
    return UserProfileModel(
      id: authUserId.toString(),
      email: email,
      name: email.split('@').first,
      createdAt: DateTime.now(),
    );
  }
}
