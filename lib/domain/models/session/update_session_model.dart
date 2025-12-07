import 'package:equatable/equatable.dart';

class UpdateSessionModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime tokenExpiresAt;

  const UpdateSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpiresAt,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenExpiresAt];

  @override
  bool get stringify => true;
}
