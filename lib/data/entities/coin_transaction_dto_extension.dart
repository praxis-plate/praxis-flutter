import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:codium/domain/models/coin_transaction/coin_transaction_model.dart';
import 'package:codium/domain/models/coin_transaction/wallet_balance.dart';
import 'package:praxis_client/praxis_client.dart'
    as client
    show CoinTransactionType;
import 'package:praxis_client/praxis_client.dart' hide CoinTransactionType;

extension CoinTransactionDtoExtension on CoinTransactionDto {
  CoinTransactionModel toDomain() {
    return CoinTransactionModel(
      id: id,
      userId: authUserId,
      amount: amount,
      type: _mapServerTypeToDomain(type).name,
      transactionKey: transactionKey,
      relatedEntityId: relatedEntityId,
      createdAt: createdAt,
    );
  }

  CoinTransactionType _mapServerTypeToDomain(
    client.CoinTransactionType serverType,
  ) {
    switch (serverType) {
      case client.CoinTransactionType.buy:
        return CoinTransactionType.coursePurchase;
      case client.CoinTransactionType.topUp:
        return CoinTransactionType.initialGrant;
      default:
        return CoinTransactionType.initialGrant;
    }
  }
}

extension WalletBalanceDtoExtension on WalletBalanceDto {
  WalletBalance toDomain() {
    return WalletBalance(
      balance: balance.toDouble(),
      available: available.toDouble(),
      held: held.toDouble(),
      currency: currency,
    );
  }
}
