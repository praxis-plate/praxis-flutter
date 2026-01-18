import 'package:codium/core/error/error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/core/validators/email_validator.dart';
import 'package:codium/core/validators/password_validator.dart';
import 'package:codium/core/validators/verification_code_validator.dart';
import 'package:codium/domain/usecases/auth/finish_password_reset_usecase.dart';
import 'package:codium/domain/usecases/auth/start_password_reset_usecase.dart';
import 'package:codium/domain/usecases/auth/verify_password_reset_code_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final StartPasswordResetUseCase _startPasswordResetUseCase;
  final VerifyPasswordResetCodeUseCase _verifyPasswordResetCodeUseCase;
  final FinishPasswordResetUsecase _finishPasswordResetUseCase;

  ForgotPasswordCubit(
    this._startPasswordResetUseCase,
    this._verifyPasswordResetCodeUseCase,
    this._finishPasswordResetUseCase,
  ) : super(const ForgotPasswordState());

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

  Future<void> submit() async {
    if (!state.isValid) return;

    switch (state.step) {
      case ForgotPasswordStep.email:
        await _startPasswordReset();
        break;
      case ForgotPasswordStep.verifyCode:
        await _verifyPasswordResetCode();
        break;
      case ForgotPasswordStep.newPassword:
        await _finishPasswordReset();
        break;
    }
  }

  Future<void> _startPasswordReset() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _startPasswordResetUseCase(state.email.value);

    result.when(
      success: (requestId) {
        emit(
          state.copyWith(
            step: ForgotPasswordStep.verifyCode,
            passwordResetRequestId: requestId,
            status: FormzSubmissionStatus.initial,
            isValid: _isValidForStep(
              ForgotPasswordStep.verifyCode,
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

  Future<void> _verifyPasswordResetCode() async {
    final requestId = state.passwordResetRequestId;
    if (requestId == null) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _verifyPasswordResetCodeUseCase(
      passwordResetRequestId: requestId,
      verificationCode: state.verificationCode.value,
    );

    result.when(
      success: (finishToken) {
        emit(
          state.copyWith(
            step: ForgotPasswordStep.newPassword,
            finishPasswordResetToken: finishToken,
            status: FormzSubmissionStatus.initial,
            isValid: _isValidForStep(
              ForgotPasswordStep.newPassword,
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

  Future<void> _finishPasswordReset() async {
    final finishToken = state.finishPasswordResetToken;
    if (finishToken == null) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _finishPasswordResetUseCase(
      finishPasswordResetToken: finishToken,
      newPassword: state.password.value,
    );

    result.when(
      success: (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
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

  void reset() => emit(const ForgotPasswordState());

  bool _isValidForStep(
    ForgotPasswordStep step, {
    required EmailValidator email,
    required VerificationCodeValidator verificationCode,
    required PasswordValidator password,
  }) {
    return switch (step) {
      ForgotPasswordStep.email => Formz.validate([email]),
      ForgotPasswordStep.verifyCode => Formz.validate([verificationCode]),
      ForgotPasswordStep.newPassword => Formz.validate([password]),
    };
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
