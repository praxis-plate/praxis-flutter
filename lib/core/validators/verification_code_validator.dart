import 'package:praxis/l10n/app_localizations.dart';
import 'package:formz/formz.dart';

class VerificationCodeValidator
    extends FormzInput<String, VerificationCodeValidationError> {
  const VerificationCodeValidator.pure() : super.pure('');
  const VerificationCodeValidator.dirty([super.value = '']) : super.dirty();

  @override
  VerificationCodeValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return VerificationCodeValidationError.empty;
    }
    return null;
  }

  String? stringDisplayError(AppLocalizations s) =>
      isPure ? null : error?.toErrorText(s);
}

enum VerificationCodeValidationError {
  empty;

  String toErrorText(AppLocalizations s) {
    return s.errorValidationInvalid;
  }
}
