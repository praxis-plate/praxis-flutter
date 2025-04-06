class UserException implements Exception {
  final String message;
  UserException(this.message);
}

class ProfileException extends UserException {
  ProfileException(super.message);
}
