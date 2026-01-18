import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:equatable/equatable.dart';

class CreateCoinTransactionModel extends Equatable {
  final String userId;
  final int amount;
  final CoinTransactionType type;
  final String? relatedEntityId;

  const CreateCoinTransactionModel({
    required this.userId,
    required this.amount,
    required this.type,
    this.relatedEntityId,
  });

  @override
  List<Object?> get props => [userId, amount, type, relatedEntityId];

  @override
  bool get stringify => true;
}
