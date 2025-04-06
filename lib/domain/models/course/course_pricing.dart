class CoursePricing {
  final double price;
  final String currency;
  final bool hasCertification;
  final bool hasLifetimeAccess;

  CoursePricing({
    required this.price,
    this.currency = 'USD',
    this.hasCertification = false,
    this.hasLifetimeAccess = true,
  });

factory CoursePricing.free() {
    return CoursePricing(
      price: 0,
      currency: 'USD',
      hasCertification: false,
      hasLifetimeAccess: true,
    );
  }
}
