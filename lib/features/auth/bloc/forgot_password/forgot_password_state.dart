part of 'forgot_password_cubit.dart';

enum ForgotPasswordStep { email, verifyCode, newPassword }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.step = ForgotPasswordStep.email,
    this.email = const EmailValidator.pure(),
    this.verificationCode = const VerificationCodeValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.passwordResetRequestId,
    this.finishPasswordResetToken,
    this.errorCode,
  });

  final ForgotPasswordStep step;
  final EmailValidator email;
  final VerificationCodeValidator verificationCode;
  final PasswordValidator password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? passwordResetRequestId;
  final String? finishPasswordResetToken;
  final AppErrorCode? errorCode;

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    EmailValidator? email,
    VerificationCodeValidator? verificationCode,
    PasswordValidator? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? passwordResetRequestId,
    String? finishPasswordResetToken,
    AppErrorCode? errorCode,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      email: email ?? this.email,
      verificationCode: verificationCode ?? this.verificationCode,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      passwordResetRequestId:
          passwordResetRequestId ?? this.passwordResetRequestId,
      finishPasswordResetToken:
          finishPasswordResetToken ?? this.finishPasswordResetToken,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
    step,
    email,
    verificationCode,
    password,
    status,
    isValid,
    passwordResetRequestId,
    finishPasswordResetToken,
    errorCode,
  ];
}
