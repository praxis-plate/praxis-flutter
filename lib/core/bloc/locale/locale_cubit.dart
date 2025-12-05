import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const _localeKey = 'app_locale';
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs)
    : super(LocaleState(locale: _getInitialLocale(_prefs)));

  static Locale _getInitialLocale(SharedPreferences prefs) {
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      return Locale(localeCode);
    }
    return const Locale('ru');
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
    emit(LocaleState(locale: locale));
  }

  Future<void> toggleLocale() async {
    final newLocale = state.locale.languageCode == 'ru'
        ? const Locale('en')
        : const Locale('ru');
    await setLocale(newLocale);
  }
}
