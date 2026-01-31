import 'package:praxis_client/praxis_client.dart';

class CoinTransactionRemoteDataSource {
  final Client _client;

  const CoinTransactionRemoteDataSource(this._client);

  Future<List<CoinTransactionDto>> getTransactionHistory() async {
    return await _client.wallet.getHistory();
  }

  Future<CoinTransactionDto> createTransaction({
    required int amount,
    required CoinTransactionType type,
    required String transactionKey,
    int? relatedEntityId,
  }) async {
    final request = CreateCoinTransactionRequest(
      amount: amount,
      currency: 'COIN',
      type: type,
      transactionKey: transactionKey,
      relatedEntityId: relatedEntityId?.toString(),
    );

    switch (type) {
      case CoinTransactionType.buy:
        return await _client.wallet.buy(request);
      case CoinTransactionType.topUp:
        return await _client.wallet.topUp(request);
      default:
        throw ArgumentError(
          'Unsupported transaction type for wallet operations: $type',
        );
    }
  }

  Future<WalletBalanceDto> getWalletBalance() async {
    return await _client.wallet.getBalance();
  }
}
