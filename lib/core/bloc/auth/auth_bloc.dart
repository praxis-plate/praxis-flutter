import 'package:codium/core/utils/result.dart';
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
       super(const AuthLoadingState()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await _checkAuthStatusUseCase();

      if (!result.isSuccess) {
        emit(const AuthUnauthenticatedState());
        return;
      }

      final user = result.dataOrNull;
      if (user == null) {
        emit(const AuthUnauthenticatedState());
        return;
      }

      emit(AuthAuthenticatedState(userId: user.id, email: user.email));
    } catch (e, st) {
      emit(const AuthUnauthenticatedState());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoadingState());

      final result = await _signUpUseCase(event.email, event.password);

      if (!result.isSuccess) {
        emit(const AuthUnauthenticatedState());
        GetIt.I<Talker>().error(
          'Sign up failed: ${result.failureOrNull!.message}',
        );
        return;
      }

      final user = result.dataOrNull!;
      emit(AuthAuthenticatedState(userId: user.id, email: user.email));
    } catch (e, st) {
      emit(const AuthUnauthenticatedState());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoadingState());

      final result = await _signInUseCase(event.email, event.password);

      if (!result.isSuccess) {
        emit(const AuthUnauthenticatedState());
        GetIt.I<Talker>().error(
          'Sign in failed: ${result.failureOrNull!.message}',
        );
        return;
      }

      final user = result.dataOrNull!;
      emit(AuthAuthenticatedState(userId: user.id, email: user.email));
    } catch (e, st) {
      emit(const AuthUnauthenticatedState());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoadingState());

      final result = await _signOutUseCase();

      if (!result.isSuccess) {
        GetIt.I<Talker>().error(
          'Sign out failed: ${result.failureOrNull!.message}',
        );
      }

      emit(const AuthUnauthenticatedState());
    } catch (e, st) {
      emit(const AuthUnauthenticatedState());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
