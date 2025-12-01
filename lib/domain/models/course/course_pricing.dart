import 'package:codium/domain/models/user/money.dart';

class CoursePricing {
  final Money price;
  final bool hasCertification;

  CoursePricing({required this.price, this.hasCertification = false});

  factory CoursePricing.free() => CoursePricing(price: Money.zero());
}
