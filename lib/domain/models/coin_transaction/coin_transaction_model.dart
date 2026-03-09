import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:equatable/equatable.dart';

class CoinTransactionModel extends Equatable {
  final int id;
  final String userId;
  final int amount;
  final CoinTransactionType type;
  final String transactionKey;
  final String? relatedEntityId;
  final DateTime createdAt;

  const CoinTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.transactionKey,
    this.relatedEntityId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    amount,
    type,
    transactionKey,
    relatedEntityId,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
