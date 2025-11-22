import 'package:codium/core/exceptions/auth_exceptions.dart';

class AuthValidator {
  static const int _minPasswordLength = 8;

  static bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= _minPasswordLength;
  }

  static void validateCredentials(String email, String password) {
    if (!isValidEmail(email)) {
      throw AuthValidationException('Invalid email format');
    }

    if (!isValidPassword(password)) {
      throw AuthValidationException(
        'Password must contain at least $_minPasswordLength characters',
      );
    }
  }
}
