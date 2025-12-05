import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  final int userId;
  final String email;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiresAt;

  const SessionModel({
    required this.userId,
    required this.email,
    this.accessToken,
    this.refreshToken,
    this.tokenExpiresAt,
  });

  bool get hasValidToken {
    if (accessToken == null || tokenExpiresAt == null) return false;
    return DateTime.now().isBefore(tokenExpiresAt!);
  }

  @override
  List<Object?> get props => [
    userId,
    email,
    accessToken,
    refreshToken,
    tokenExpiresAt,
  ];

  @override
  bool get stringify => true;
}
