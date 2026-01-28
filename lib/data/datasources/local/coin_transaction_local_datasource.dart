import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_coin_transaction_datasource.dart';

class CoinTransactionLocalDataSource
    implements ICoinTransactionDataSource {
  final AppDatabase _db;

  const CoinTransactionLocalDataSource(this._db);

  @override
  Future<List<CoinTransactionEntity>> getTransactionHistory(String userId) async {
    return await _db.managers.coinTransaction
        .filter((f) => f.userId.id(userId))
        .get();
  }

  @override
  Future<CoinTransactionEntity> insertTransaction(
    CoinTransactionCompanion entry,
  ) async {
    return await _db.into(_db.coinTransaction).insertReturning(entry);
  }
}
