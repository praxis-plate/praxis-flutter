// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

enum Currency {
  usd(symbol: '\$', code: 'USD'),
  rub(symbol: '₽', code: 'RUB'),
  eur(symbol: '€', code: 'EUR');

  final String symbol;
  final String code;

  const Currency({required this.symbol, required this.code});

  static Currency fromCode(String code) {
    return values.firstWhere(
      (c) => c.code == code.toUpperCase(),
      orElse: () => throw ArgumentError('Unknown currency code: $code'),
    );
  }
}

class Money extends Equatable {
  final Decimal amount;
  final Currency currency;

  const Money({
    required this.amount,
    required this.currency,
  });

  String format() => '${currency.symbol} $amount';

  String get currencyCode => currency.code;

  factory Money.fromCode({
    required Decimal amount,
    required String currencyCode,
  }) =>
      Money(
        amount: amount,
        currency: Currency.fromCode(currencyCode),
      );

  Money copyWith({
    Decimal? amount,
    Currency? currency,
  }) {
    return Money(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object> get props => [amount, currency];
}
