import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:praxis/domain/usecases/auth/sign_in_usecase.dart';
import 'package:praxis/domain/usecases/auth/sign_out_usecase.dart';
import 'package:praxis/domain/usecases/auth/sign_up_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _signUpUseCase = signUpUseCase,
       _signInUseCase = signInUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthUnauthenticatedState()) {
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoadingState());

      final result = await _signUpUseCase(
        event.email,
        event.password,
        event.registrationToken,
      );

      if (result.isFailure) {
        final errorCode = result.failureOrNull!.code;
        emit(AuthErrorState(errorCode: errorCode));
        return;
      }

      final user = result.dataOrNull!;
      emit(AuthAuthenticatedState(user: user));
    } catch (e, st) {
      emit(const AuthUnauthenticatedState());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoadingState());

      final result = await _signInUseCase(event.email, event.password);

      if (result.isFailure) {
        final errorCode = result.failureOrNull!.code;
        emit(AuthErrorState(errorCode: errorCode));
        return;
      }

      final user = result.dataOrNull!;
      emit(AuthAuthenticatedState(user: user));
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

      if (result.isFailure) {
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

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
