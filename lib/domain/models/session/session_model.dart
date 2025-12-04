import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  final int userId;
  final String email;

  const SessionModel({required this.userId, required this.email});

  @override
  List<Object?> get props => [userId, email];

  @override
  bool get stringify => true;
}
