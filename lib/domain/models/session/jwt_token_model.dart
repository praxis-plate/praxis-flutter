import 'package:equatable/equatable.dart';

class JwtTokenModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const JwtTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];

  @override
  bool get stringify => true;
}
