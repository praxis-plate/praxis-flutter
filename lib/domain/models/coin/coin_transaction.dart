import 'package:praxis/domain/enums/coin_transaction_type.dart';
import 'package:equatable/equatable.dart';

class CoinTransaction extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final CoinTransactionType type;
  final String? relatedEntityId;
  final DateTime createdAt;

  const CoinTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.relatedEntityId,
    required this.createdAt,
  });

  CoinTransaction copyWith({
    String? id,
    String? userId,
    int? amount,
    CoinTransactionType? type,
    String? relatedEntityId,
    DateTime? createdAt,
  }) {
    return CoinTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    amount,
    type,
    relatedEntityId,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
