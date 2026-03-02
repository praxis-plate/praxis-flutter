import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:codium/domain/models/coin_transaction/coin_transaction_model.dart';

extension CoinTransactionExtension on CoinTransactionEntity {
  CoinTransactionModel toDomain() {
    return CoinTransactionModel(
      id: id,
      userId: userId,
      amount: amount,
      type: _mapStringToDomainType(type).name,
      transactionKey: 'local_tx_$id', // Generated key for local transactions
      relatedEntityId: relatedEntityId,
      createdAt: createdAt,
    );
  }

  CoinTransactionType _mapStringToDomainType(String typeString) {
    return CoinTransactionType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => CoinTransactionType.initialGrant,
    );
  }
}
