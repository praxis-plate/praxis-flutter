import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';

extension UserEntityExtension on UserEntity {
  UserProfileModel toDomain() {
    return UserProfileModel(
      id: id,
      email: email,
      name: email.split('@').first,
      createdAt: createdAt,
    );
  }
}
