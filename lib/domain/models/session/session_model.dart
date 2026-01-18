import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  final String userId;
  final String email;
  final String accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiresAt;

  const SessionModel({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpiresAt,
  });

  bool get hasValidToken {
    return tokenExpiresAt is DateTime && DateTime.now().isBefore(tokenExpiresAt!);
  }

  SessionModel copyWith({
    String? userId,
    String? email,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  }) {
    return SessionModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
    );
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
