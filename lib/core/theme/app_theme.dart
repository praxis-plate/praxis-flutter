import 'package:flutter/material.dart';

abstract interface class AppPalette {
  Color get primary;
  Color get primaryContainer;
  Color get surface;
  Color get grey;
  Color get greyBright;
  Color get onPrimary;
  Color get onSurface;
  Color get error;
  Color get onError;
}

class AppDarkPalette implements AppPalette {
  static const _primary = Colors.indigoAccent;
  static final _primaryContainer = Colors.indigoAccent.withValues(alpha: .5);
  static const _surface = Colors.black;
  static const _grey = Colors.white10;
  static const _greyBright = Colors.grey;
  static const _onPrimary = Colors.white70;
  static const _onSurface = Colors.white;
  static final _error = Colors.red.shade400;
  static const _onError = Colors.white;

  @override
  Color get primary => _primary;

  @override
  Color get primaryContainer => _primaryContainer;

  @override
  Color get surface => _surface;

  @override
  Color get grey => _grey;

  @override
  Color get greyBright => _greyBright;

  @override
  Color get onSurface => _onSurface;

  @override
  Color get error => _error;

  @override
  Color get onError => _onError;

  @override
  Color get onPrimary => _onPrimary;
}

class AppLightPalette implements AppPalette {
  static const _primary = Colors.indigoAccent;
  static final _primaryContainer = Colors.indigoAccent.withValues(alpha: .5);
  static const _surface = Colors.white;
  static const _grey = Colors.black12;
  static const _greyBright = Colors.grey;
  static const _onPrimary = Colors.white;
  static const _onSurface = Colors.black;
  static final _error = Colors.red.shade400;
  static const _onError = Colors.black;

  @override
  Color get primary => _primary;

  @override
  Color get primaryContainer => _primaryContainer;

  @override
  Color get surface => _surface;

  @override
  Color get grey => _grey;

  @override
  Color get greyBright => _greyBright;

  @override
  Color get onSurface => _onSurface;

  @override
  Color get error => _error;

  @override
  Color get onError => _onError;

  @override
  Color get onPrimary => _onPrimary;
}

class AppTheme {
  static final AppDarkPalette _appDarkPalette = AppDarkPalette();
  static final AppLightPalette _appLightPalette = AppLightPalette();

  static OutlineInputBorder _border(AppPalette palette, [Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: palette.grey,
        width: 2,
      ),
    );
  }

  static TextTheme _textTheme(AppPalette palette) {
    return TextTheme(
      // Page announcements
      displayLarge: TextStyle(
        color: palette.onSurface,
        fontSize: 52,
      ),
      // View title
      titleLarge: TextStyle(
        color: palette.onSurface,
        fontSize: 26,
        fontWeight: FontWeight.w500,
      ),
      // Element title
      titleMedium: TextStyle(
        color: palette.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      // Section title
      titleSmall: TextStyle(
        color: palette.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: palette.greyBright,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        color: palette.greyBright,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        color: palette.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: palette.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: palette.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static IconThemeData _iconTheme(AppPalette palette) {
    return IconThemeData(
      color: palette.greyBright,
      size: 26,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(AppPalette palette) {
    final border = _border(palette, palette.error);
    final borderPrimary = _border(palette, palette.primary);
    final borderError = _border(palette, palette.error);
    final textTheme = _textTheme(palette);

    return InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      border: border,
      enabledBorder: border,
      focusedBorder: borderPrimary,
      errorBorder: borderError,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: palette.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(AppPalette palette) {
    final textTheme = _textTheme(palette);

    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        textStyle: textTheme.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(AppPalette palette) {
    final textTheme = _textTheme(palette);
    final iconTheme = _iconTheme(palette);

    return NavigationBarThemeData(
      backgroundColor: palette.surface,
      elevation: 0,
      indicatorColor: palette.primary,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.bodySmall?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.bold,
            );
          }

          return textTheme.bodySmall?.copyWith(
            color: palette.greyBright,
          );
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return iconTheme.copyWith(
              color: palette.primary,
            );
          }

          return iconTheme;
        },
      ),
    );
  }

  static _chipThemeData(AppPalette palette) {
    final textTheme = _textTheme(palette);

    return ChipThemeData(
      color: WidgetStateProperty.resolveWith((state) {
        if (state.contains(WidgetState.selected)) {
          return palette.primary;
        }
        return palette.surface;
      }),
      side: BorderSide(color: palette.grey),
      labelStyle: textTheme.labelMedium,
    );
  }

  static DividerThemeData _dividerTheme(AppPalette palette) {
    return DividerThemeData(
      color: palette.grey,
      indent: 16,
      endIndent: 16,
      space: 0,
      thickness: 1,
    );
  }

  static _listTileTheme(AppPalette palette) {
    final textTheme = _textTheme(palette);

    ListTileThemeData(
      titleTextStyle: textTheme.labelLarge,
      subtitleTextStyle: textTheme.labelSmall,
    );
  }

  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      surface: _appDarkPalette.surface,
      surfaceBright: _appDarkPalette.grey,
      onSurfaceVariant: _appDarkPalette.greyBright,
      onSurface: _appDarkPalette.onSurface,
      primary: _appDarkPalette.primary,
      primaryContainer: _appDarkPalette.primaryContainer,
      onPrimary: _appDarkPalette.onSurface,
      error: _appDarkPalette.error,
      onError: _appDarkPalette.onError,
    ),
    textTheme: _textTheme(_appDarkPalette),
    inputDecorationTheme: _inputDecorationTheme(_appDarkPalette),
    elevatedButtonTheme: _elevatedButtonTheme(_appDarkPalette),
    navigationBarTheme: _navigationBarTheme(_appDarkPalette),
    chipTheme: _chipThemeData(_appDarkPalette),
    dividerTheme: _dividerTheme(_appDarkPalette),
    scaffoldBackgroundColor: _appDarkPalette.surface,
    primaryColor: _appDarkPalette.primary,
    listTileTheme: _listTileTheme(_appDarkPalette),
  );

  static final lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
      surface: _appLightPalette.surface,
      surfaceBright: _appLightPalette.grey,
      onSurfaceVariant: _appLightPalette.greyBright,
      onSurface: _appLightPalette.onSurface,
      primary: _appLightPalette.primary,
      primaryContainer: _appLightPalette.primaryContainer,
      onPrimary: _appLightPalette.onSurface,
      error: _appLightPalette.error,
      onError: _appLightPalette.onError,
    ),
    textTheme: _textTheme(_appLightPalette),
    inputDecorationTheme: _inputDecorationTheme(_appLightPalette),
    elevatedButtonTheme: _elevatedButtonTheme(_appLightPalette),
    navigationBarTheme: _navigationBarTheme(_appLightPalette),
    chipTheme: _chipThemeData(_appLightPalette),
    dividerTheme: _dividerTheme(_appLightPalette),
    scaffoldBackgroundColor: _appLightPalette.surface,
    primaryColor: _appLightPalette.primary,
    listTileTheme: _listTileTheme(_appLightPalette),
  );
}
