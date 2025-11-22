class UserException implements Exception {
  final String message;
  UserException(this.message);

  @override
  String toString() => message;
}

class ProfileException extends UserException {
  ProfileException(super.message);
}
