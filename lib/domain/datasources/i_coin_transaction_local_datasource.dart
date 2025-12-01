import 'package:codium/data/database/app_database.dart';

abstract interface class ICoinTransactionLocalDataSource {
  Future<List<CoinTransactionEntity>> getTransactionHistory(int userId);
  Future<CoinTransactionEntity> insertTransaction(
    CoinTransactionCompanion entry,
  );
}
