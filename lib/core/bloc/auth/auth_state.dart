part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading,
  error,
}

sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthAuthenticatedState extends AuthState {
  const AuthAuthenticatedState();
}

class AuthUnauthenticatedState extends AuthState {
  final String? redirectReason;
  
  const AuthUnauthenticatedState({this.redirectReason});

  @override
  List<Object?> get props => [redirectReason];
}

class AuthErrorState extends AuthState {
  final String message;
  
  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
