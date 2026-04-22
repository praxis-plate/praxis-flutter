import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/update_user_profile_model.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';

abstract interface class IUserRepository {
  Future<Result<UserProfileModel>> getCurrentUser();
  Future<Result<UserProfileModel>> getUserById(String userId);
  Future<Result<void>> updateUser(UpdateUserProfileModel user);
}
