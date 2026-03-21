import 'package:praxis/l10n/app_localizations.dart';
import 'package:formz/formz.dart';

class EmailValidator extends FormzInput<String, EmailValidationError> {
  const EmailValidator.pure() : super.pure('');
  const EmailValidator.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  @override
  EmailValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return EmailValidationError.empty;
    }
    if (!_emailRegex.hasMatch(value!)) {
      return EmailValidationError.invalid;
    }
    return null;
  }

  String? stringDisplayError(AppLocalizations s) =>
      isPure ? null : error?.toErrorText(s);
}

enum EmailValidationError {
  empty,
  invalid;

  String toErrorText(AppLocalizations s) {
    switch (this) {
      case EmailValidationError.empty:
        return s.errorEmailEmpty;
      case EmailValidationError.invalid:
        return s.errorEmailInvalid;
    }
  }
}
