class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthValidationException extends AuthException {
  AuthValidationException(super.message);
}

class AuthServerException extends AuthException {
  AuthServerException(super.message);
}

class AuthUserAlreadyExistsException extends AuthException {
  AuthUserAlreadyExistsException(super.message);
}
