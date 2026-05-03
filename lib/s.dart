import 'package:praxis/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class S {
  static const supportedLocales = [Locale('en'), Locale('ru')];

  static const localizationDelegates = <LocalizationsDelegate>[
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    // ignore: unnecessary_non_null_assertion
    return AppLocalizations.of(context)!;
  }
}
