import 'package:codium/l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class VerificationCodeValidator
    extends FormzInput<String, VerificationCodeValidationError> {
  const VerificationCodeValidator.pure() : super.pure('');
  const VerificationCodeValidator.dirty([super.value = '']) : super.dirty();

  @override
  VerificationCodeValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) return VerificationCodeValidationError.empty;
    return null;
  }

  String? stringDisplayError(AppLocalizations? s) =>
      isPure ? null : error?.toErrorText(s);
}

enum VerificationCodeValidationError {
  empty;

  String toErrorText(AppLocalizations? s) {
    if (s == null) {
      GetIt.I<Talker>().log('VerificationCodeValidator unhandled error');
      return 'Unhandled error';
    }

    return s.errorValidationInvalid;
  }
}
