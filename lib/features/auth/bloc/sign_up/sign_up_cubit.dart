import 'dart:async';

import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/error/error.dart';
import 'package:codium/core/validators/email_validator.dart';
import 'package:codium/core/validators/password_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.authBloc}) : super(const SignUpState()) {
    streamSubscription = authBloc.stream.listen((AuthState authState) {
      if (authState is AuthErrorState) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorCode: authState.errorCode,
          ),
        );
      }
    });
  }

  final AuthBloc authBloc;
  late final StreamSubscription streamSubscription;

  void emailChanged(String value) {
    final email = EmailValidator.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordValidator.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  void setSubmissionInProgress() {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
  }

  void reset() => emit(state.copyWith(status: FormzSubmissionStatus.initial));

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
