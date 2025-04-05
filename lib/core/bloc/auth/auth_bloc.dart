import 'package:codium/repositories/codium_auth/abstract_auth_repository.dart';
import 'package:codium/repositories/codium_courses/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState.unauthenticated()) {
    on<AuthLogoutEvent>(_onAuthLogout);
    on<AuthLoginEvent>(_onAuthLogin);
    on<AuthRegisterEvent>(_onAuthRegister);
  }

  Future<void> _onAuthLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onAuthLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _authRepository.login(event.email, event.password);
    emit(AuthState.authenticated(user));
  }

  Future<void> _onAuthRegister(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _authRepository.signUp(event.email, event.password);
    emit(AuthState.authenticated(user));
  }
}
