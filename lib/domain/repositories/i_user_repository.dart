import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/update_user_profile_model.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';

abstract interface class IUserRepository {
  Future<Result<UserProfileModel>> getCurrentUser();
  Future<Result<UserProfileModel>> getUserById(int userId);
  Future<Result<void>> updateUser(UpdateUserProfileModel user);
}
