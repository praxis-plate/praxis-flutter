part of 'sign_in_cubit.dart';

final class SignInState extends Equatable {
  final EmailValidator email;
  final PasswordValidator password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final AppErrorCode? errorCode;

  const SignInState({
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorCode,
  });

  SignInState copyWith({
    EmailValidator? email,
    PasswordValidator? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? obscurePassword,
    AppErrorCode? errorCode,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [email, password, status, isValid, errorCode];
}
