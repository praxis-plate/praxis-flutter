import 'package:praxis/l10n/app_localizations.dart';
import 'package:formz/formz.dart';

class PasswordValidator extends FormzInput<String, PasswordValidationError> {
  const PasswordValidator.pure() : super.pure('');
  const PasswordValidator.dirty([super.value = '']) : super.dirty();

  static final _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return PasswordValidationError.empty;
    }
    if (!_passwordRegex.hasMatch(value!)) {
      return PasswordValidationError.invalid;
    }
    return null;
  }

  String? stringDisplayError(AppLocalizations s) =>
      isPure ? null : error?.toErrorText(s);
}

enum PasswordValidationError {
  empty,
  invalid;

  String toErrorText(AppLocalizations s) {
    switch (this) {
      case PasswordValidationError.empty:
        return s.errorPasswordEmpty;
      case PasswordValidationError.invalid:
        return s.errorPasswordInvalid;
    }
  }
}
