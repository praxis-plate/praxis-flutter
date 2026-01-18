import 'dart:ffi';

import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:codium/domain/models/coin_transaction/coin_transaction_model.dart';
import 'package:codium/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:drift/drift.dart';

extension CoinTransactionEntityExtension on CoinTransactionEntity {
  CoinTransactionModel toDomain() {
    return CoinTransactionModel(
      id: id,
      userId: userId,
      amount: amount,
      type: CoinTransactionType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => CoinTransactionType.initialGrant,
      ),
      relatedEntityId: relatedEntityId,
      createdAt: createdAt,
    );
  }
}

extension CreateCoinTransactionModelExtension on CreateCoinTransactionModel {
  CoinTransactionCompanion toCompanion() {
    return CoinTransactionCompanion.insert(
      userId: userId,
      amount: amount,
      type: type.name,
      relatedEntityId: Value(relatedEntityId),
      createdAt: DateTime.now(),
    );
  }
}
