import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/coin_transaction/coin_transaction_model.dart';
import 'package:codium/domain/models/coin_transaction/create_coin_transaction_model.dart';

abstract interface class ICoinTransactionRepository {
  Future<Result<List<CoinTransactionModel>>> getTransactionHistory(
    String userId,
  );
  Future<Result<void>> create(CreateCoinTransactionModel model);
}
