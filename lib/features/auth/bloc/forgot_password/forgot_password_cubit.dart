import 'package:codium/core/validators/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void emailChanged(String value) {
    final email = EmailValidator.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  Future<void> submit() async {
    if (!state.isValid) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    await Future<void>.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(status: FormzSubmissionStatus.success));
  }

  void reset() {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.initial,
      ),
    );
  }
}
