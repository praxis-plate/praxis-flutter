import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_in_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_out_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_up_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthBloc({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _signUpUseCase = signUpUseCase,
       _signInUseCase = signInUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthInitialState()) {
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthUpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoadingState());
      final user = await _signUpUseCase(event.email, event.password);
      emit(AuthAuthenticatedState(user));
    } catch (e, st) {
      emit(AuthErrorState(e.toString()));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoadingState());
      final user = await _signInUseCase(event.email, event.password);
      emit(AuthAuthenticatedState(user));
    } catch (e, st) {
      emit(AuthErrorState(e.toString()));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoadingState());
      await _signOutUseCase();
      emit(const AuthUnauthenticatedState());
    } catch (e, st) {
      emit(AuthErrorState(e.toString()));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      final currentUser = await _checkAuthStatusUseCase();
      if (currentUser != null) {
        emit(AuthAuthenticatedState(currentUser));
      } else {
        emit(const AuthUnauthenticatedState());
      }
    } catch (e, st) {
      emit(const AuthUnauthenticatedState());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  void _onUpdateUser(AuthUpdateUserEvent event, Emitter<AuthState> emit) {
    if (state is AuthAuthenticatedState) {
      emit(AuthAuthenticatedState(event.updatedUser));
    }
  }
}
