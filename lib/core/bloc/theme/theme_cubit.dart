import 'package:praxis/core/theme/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _themeKey = 'app_theme_is_dark';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs, Brightness platformBrightness)
    : super(ThemeState(_getInitialTheme(_prefs, platformBrightness)));

  static bool _getInitialTheme(
    SharedPreferences prefs,
    Brightness platformBrightness,
  ) {
    final savedTheme = prefs.getBool(_themeKey);
    if (savedTheme != null) {
      return savedTheme;
    }
    return platformBrightness == Brightness.dark;
  }

  Future<void> setDarkTheme(bool value) async {
    await _prefs.setBool(_themeKey, value);
    emit(ThemeState(value));
  }
}
