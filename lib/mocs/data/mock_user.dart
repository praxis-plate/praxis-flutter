import 'package:codium/domain/models/models.dart';
import 'package:decimal/decimal.dart';

var mockUser = User(
  id: 'mock_1',
  name: 'Тестовый Пользователь',
  email: 'test@example.com',
  balance: Money(amount: Decimal.fromInt(100), currency: Currency.eur),
  purchasedCourseIds: const [],
);
