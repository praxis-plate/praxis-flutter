import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/coin_transaction/wallet_balance.dart';

abstract interface class ICoinTransactionDataSource {
  Future<List<CoinTransactionEntity>> getTransactionHistory();
  Future<CoinTransactionEntity> createTransaction({
    required double amount,
    required String type,
    required String transactionKey,
    int? relatedEntityId,
  });
  Future<WalletBalance> getWalletBalance();
}
