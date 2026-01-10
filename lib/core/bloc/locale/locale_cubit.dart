import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const _localeKey = 'app_locale';
  final SharedPreferences _preferences;

  LocaleCubit(this._preferences)
    : super(LocaleState(locale: _getInitialLocale(_preferences)));

  static Locale _getInitialLocale(SharedPreferences preferences) {
    final localeCode = preferences.getString(_localeKey);
    return Locale(localeCode ?? 'ru');
  }

  Future<void> setLocale(Locale locale) async {
    if (state.locale.languageCode == locale.languageCode) {
      return;
    }

    await _preferences.setString(_localeKey, locale.languageCode);

    emit(LocaleState(locale: locale));
  }

  Future<void> toggleLocale() async {
    final newLocale = state.locale.languageCode == 'ru'
        ? const Locale('en')
        : const Locale('ru');
    return setLocale(newLocale);
  }
}
