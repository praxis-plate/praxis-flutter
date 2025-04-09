part of 'sign_in_cubit.dart';

final class SignInState extends Equatable {
  final EmailValidator email;
  final PasswordValidator password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final bool obscurePassword;

  const SignInState({
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.obscurePassword = true,
    this.errorMessage,
  });

  SignInState copyWith({
    EmailValidator? email,
    PasswordValidator? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? obscurePassword,
    String? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [email, password, status, isValid, obscurePassword, errorMessage];
}
