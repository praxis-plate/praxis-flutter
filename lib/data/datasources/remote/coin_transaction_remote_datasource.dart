import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_coin_transaction_datasource.dart';
import 'package:praxis_client/praxis_client.dart';

class CoinTransactionRemoteDataSource
    implements ICoinTransactionDataSource {
  final Client _client;

  const CoinTransactionRemoteDataSource(this._client);

  @override
  Future<List<CoinTransactionEntity>> getTransactionHistory(String userId) async {
    throw UnimplementedError(
      'Remote coin transactions are not implemented for $_client',
    );
  }

  @override
  Future<CoinTransactionEntity> insertTransaction(
    CoinTransactionCompanion entry,
  ) async {
    throw UnimplementedError(
      'Remote coin transactions are not implemented for $_client',
    );
  }
}
