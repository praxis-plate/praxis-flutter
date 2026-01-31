import 'package:equatable/equatable.dart';

class WalletBalance extends Equatable {
  final double balance;
  final double available;
  final double held;
  final String currency;

  const WalletBalance({
    required this.balance,
    required this.available,
    required this.held,
    required this.currency,
  });

  @override
  List<Object?> get props => [balance, available, held, currency];
}
