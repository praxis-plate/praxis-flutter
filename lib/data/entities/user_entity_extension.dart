import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/domain/models/user/update_user_profile_model.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:drift/drift.dart';

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

extension UpdateUserProfileModelExtension on UpdateUserProfileModel {
  UserCompanion toCompanion() {
    return UserCompanion(
      id: Value(id),
      email: email != null ? Value(email!) : const Value.absent(),
    );
  }
}
