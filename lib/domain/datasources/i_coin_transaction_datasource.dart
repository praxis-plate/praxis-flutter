import 'package:codium/data/database/app_database.dart';

abstract interface class ICoinTransactionDataSource {
  Future<List<CoinTransactionEntity>> getTransactionHistory(String userId);
  Future<CoinTransactionEntity> insertTransaction(
    CoinTransactionCompanion entry,
  );
}
