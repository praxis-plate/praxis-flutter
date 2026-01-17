import 'package:codium/core/config/test_user_config.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/core/validators/auth_validator.dart';
import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:codium/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:codium/domain/repositories/i_auth_repository.dart';
import 'package:codium/domain/repositories/i_coin_transaction_repository.dart';

class SignUpUseCase {
  final IAuthRepository _authRepository;
  final ICoinTransactionRepository _coinTransactionRepository;

  SignUpUseCase(this._authRepository, this._coinTransactionRepository);

  Future<Result<UserProfileModel>> call(
    String email,
    String password,
    String registrationToken,
  ) async {
    AuthValidator.validateCredentials(email, password);

    final userResult = await _authRepository.signUp(
      email: email,
      password: password,
      registrationToken: registrationToken,
    );

    return userResult.when(
      success: (user) async {
        final transaction = CreateCoinTransactionModel(
          userId: user.id,
          amount: TestUserConfig.initialBalance,
          type: CoinTransactionType.initialGrant,
          relatedEntityId: null,
        );
        await _coinTransactionRepository.create(transaction);

        return Success(user);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
