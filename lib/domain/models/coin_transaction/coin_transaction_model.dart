import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:equatable/equatable.dart';

class CoinTransactionModel extends Equatable {
  final int id;
  final int userId;
  final int amount;
  final CoinTransactionType type;
  final String? relatedEntityId;
  final DateTime createdAt;

  const CoinTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.relatedEntityId,
    required this.createdAt,
  });

  CoinTransactionModel copyWith({
    int? id,
    int? userId,
    int? amount,
    CoinTransactionType? type,
    String? relatedEntityId,
    DateTime? createdAt,
  }) {
    return CoinTransactionModel(
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
