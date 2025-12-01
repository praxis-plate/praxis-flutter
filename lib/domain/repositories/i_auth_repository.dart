import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';

abstract interface class IAuthRepository {
  Future<Result<UserProfileModel>> signUp(String email, String password);
  Future<Result<UserProfileModel>> signIn(String email, String password);
  Future<Result<void>> signOut();
  Future<Result<bool>> isAuthenticated();
}
