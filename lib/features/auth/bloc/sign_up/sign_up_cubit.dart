import 'dart:async';

import 'package:praxis/core/bloc/auth/auth_bloc.dart';
import 'package:praxis/core/error/error.dart';
import 'package:praxis/core/utils/utils.dart';
import 'package:praxis/core/validators/email_validator.dart';
import 'package:praxis/core/validators/password_validator.dart';
import 'package:praxis/core/validators/verification_code_validator.dart';
import 'package:praxis/domain/usecases/auth/start_registration_usecase.dart';
import 'package:praxis/domain/usecases/auth/verify_registration_code_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required this.authBloc,
    required StartRegistrationUseCase startRegistrationUseCase,
    required VerifyRegistrationCodeUseCase verifyRegistrationCodeUseCase,
  }) : _startRegistrationUseCase = startRegistrationUseCase,
       _verifyRegistrationCodeUseCase = verifyRegistrationCodeUseCase,
       super(const SignUpState()) {
    streamSubscription = authBloc.stream.listen((AuthState authState) {
      if (authState is AuthErrorState) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorCode: authState.errorCode,
          ),
        );
      } else if (authState is AuthAuthenticatedState) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            errorCode: null,
          ),
        );
      }
    });
  }

  final AuthBloc authBloc;
  final StartRegistrationUseCase _startRegistrationUseCase;
  final VerifyRegistrationCodeUseCase _verifyRegistrationCodeUseCase;

  late final StreamSubscription streamSubscription;

  void emailChanged(String value) {
    final email = EmailValidator.dirty(value);
    emit(
      state.copyWith(
        email: email,
        errorCode: null,
        isValid: _isValidForStep(
          state.step,
          email: email,
          verificationCode: state.verificationCode,
          password: state.password,
        ),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordValidator.dirty(value);
    emit(
      state.copyWith(
        password: password,
        errorCode: null,
        isValid: _isValidForStep(
          state.step,
          email: state.email,
          verificationCode: state.verificationCode,
          password: password,
        ),
      ),
    );
  }

  void verificationCodeChanged(String value) {
    final verificationCode = VerificationCodeValidator.dirty(value);
    emit(
      state.copyWith(
        verificationCode: verificationCode,
        errorCode: null,
        isValid: _isValidForStep(
          state.step,
          email: state.email,
          verificationCode: verificationCode,
          password: state.password,
        ),
      ),
    );
  }

  Future<void> startRegistration() async {
    if (!state.isValid || state.step != SignUpStep.email) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _startRegistrationUseCase(state.email.value);

    result.when(
      success: (requestId) {
        emit(
          state.copyWith(
            step: SignUpStep.verifyCode,
            accountRequestId: requestId,
            status: FormzSubmissionStatus.initial,
            isValid: _isValidForStep(
              SignUpStep.verifyCode,
              email: state.email,
              verificationCode: state.verificationCode,
              password: state.password,
            ),
            errorCode: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorCode: failure.code,
          ),
        );
      },
    );
  }

  Future<void> verifyRegistrationCode() async {
    if (!state.isValid || state.step != SignUpStep.verifyCode) return;

    final requestId = state.accountRequestId;
    if (requestId == null) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _verifyRegistrationCodeUseCase(
      accountRequestId: requestId,
      verificationCode: state.verificationCode.value,
    );

    result.when(
      success: (registrationToken) {
        emit(
          state.copyWith(
            step: SignUpStep.password,
            registrationToken: registrationToken,
            status: FormzSubmissionStatus.initial,
            isValid: _isValidForStep(
              SignUpStep.password,
              email: state.email,
              verificationCode: state.verificationCode,
              password: state.password,
            ),
            errorCode: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorCode: failure.code,
          ),
        );
      },
    );
  }

  void submitRegistration() {
    if (!state.isValid || state.step != SignUpStep.password) return;
    final token = state.registrationToken;
    if (token == null) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    authBloc.add(
      AuthSignUpEvent(
        email: state.email.value,
        password: state.password.value,
        registrationToken: token,
      ),
    );
  }

  void reset() => emit(
    state.copyWith(status: FormzSubmissionStatus.initial, errorCode: null),
  );

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  bool _isValidForStep(
    SignUpStep step, {
    required EmailValidator email,
    required VerificationCodeValidator verificationCode,
    required PasswordValidator password,
  }) {
    return switch (step) {
      SignUpStep.email => Formz.validate([email]),
      SignUpStep.verifyCode => Formz.validate([verificationCode]),
      SignUpStep.password => Formz.validate([password]),
    };
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
