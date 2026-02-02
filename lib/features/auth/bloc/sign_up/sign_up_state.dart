part of 'sign_up_cubit.dart';

enum SignUpStep { email, verifyCode, password }

final class SignUpState extends Equatable {
  final SignUpStep step;
  final EmailValidator email;
  final VerificationCodeValidator verificationCode;
  final PasswordValidator password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? accountRequestId;
  final String? registrationToken;
  final AppErrorCode? errorCode;

  const SignUpState({
    this.step = SignUpStep.email,
    this.email = const EmailValidator.pure(),
    this.verificationCode = const VerificationCodeValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.accountRequestId,
    this.registrationToken,
    this.errorCode,
  });

  SignUpState copyWith({
    SignUpStep? step,
    EmailValidator? email,
    VerificationCodeValidator? verificationCode,
    PasswordValidator? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? obscurePassword,
    String? accountRequestId,
    String? registrationToken,
    AppErrorCode? errorCode,
  }) {
    return SignUpState(
      step: step ?? this.step,
      email: email ?? this.email,
      verificationCode: verificationCode ?? this.verificationCode,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      accountRequestId: accountRequestId ?? this.accountRequestId,
      registrationToken: registrationToken ?? this.registrationToken,
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
    accountRequestId,
    registrationToken,
    errorCode,
  ];
}
