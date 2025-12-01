import 'package:equatable/equatable.dart';

class Money extends Equatable {
  final int amount;

  const Money({required this.amount});

  factory Money.zero() => const Money(amount: 0);

  factory Money.fromInt(int value) => Money(amount: value);

  Money copyWith({int? amount}) {
    return Money(amount: amount ?? this.amount);
  }

  Money operator +(Money other) => Money(amount: amount + other.amount);

  Money operator -(Money other) => Money(amount: amount - other.amount);

  bool operator >(Money other) => amount > other.amount;

  bool operator >=(Money other) => amount >= other.amount;

  bool operator <(Money other) => amount < other.amount;

  bool operator <=(Money other) => amount <= other.amount;

  @override
  List<Object> get props => [amount];

  @override
  bool get stringify => true;
}
