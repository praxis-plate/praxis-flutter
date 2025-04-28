import 'package:codium/domain/models/money.dart';
import 'package:decimal/decimal.dart';

class CoursePricing {
  final Money price; // Используем Money вместо double
  final bool hasCertification;

  CoursePricing({
    required this.price,
    this.hasCertification = false,
  });

  factory CoursePricing.free() => CoursePricing(
        price: Money(amount: Decimal.zero, currency: Currency.usd),
      );
}
