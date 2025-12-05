part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthAuthenticatedState extends AuthState {
  final int userId;
  final String email;

  const AuthAuthenticatedState({required this.userId, required this.email});

  @override
  List<Object> get props => [userId, email];
}

class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}
