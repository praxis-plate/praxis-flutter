part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthAuthenticatedState extends AuthState {
  final UserProfileModel user;

  const AuthAuthenticatedState({required this.user});

  int get userId => user.id;
  String get email => user.email;

  @override
  List<Object> get props => [user];
}

class AuthErrorState extends AuthState {
  final AppErrorCode errorCode;

  const AuthErrorState({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}
