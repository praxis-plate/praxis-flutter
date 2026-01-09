part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = const EmailValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  final EmailValidator email;
  final FormzSubmissionStatus status;
  final bool isValid;

  ForgotPasswordState copyWith({
    EmailValidator? email,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [email, status, isValid];
}
