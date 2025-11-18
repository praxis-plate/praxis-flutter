import 'package:flutter/material.dart';

@immutable
class AppPalette {
  final Color primary;
  final Color primaryVariant;
  final Color card;
  final Color onSurface;
  final Color onCard;
  final Color divider;
  final Color surface;
  final Color onPrimary;
  final Color error;
  final Color onError;

  const AppPalette({
    required this.primary,
    required this.primaryVariant,
    required this.surface,
    required this.card,
    required this.divider,
    required this.onPrimary,
    required this.onCard,
    required this.onSurface,
    required this.error,
    required this.onError,
  });

  static const dark = AppPalette(
    primary: Color.fromARGB(255, 43, 230, 188),
    primaryVariant: Color.fromARGB(255, 230, 43, 85),
    card: Colors.white10,
    onSurface: Colors.white,
    onCard: Colors.white70,
    divider: Colors.white24,
    onPrimary: Colors.black,
    surface: Colors.black,
    error: Color.fromARGB(255, 254, 83, 86),
    onError: Colors.white,
  );

  static const light = AppPalette(
    primary: Color.fromARGB(255, 43, 230, 188),
    primaryVariant: Color.fromARGB(255, 41, 132, 11),
    card: Colors.white10,
    onSurface: Colors.white,
    onCard: Colors.white70,
    divider: Colors.white24,
    onPrimary: Colors.black,
    surface: Colors.black,
    error: Color.fromARGB(255, 254, 83, 86),
    onError: Colors.white,
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData of(Brightness brightness) {
    final palette =
        brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;

    return ThemeData(
      brightness: brightness,
      dividerColor: palette.divider,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.primary,
        onPrimary: palette.onPrimary,
        primaryContainer: palette.primaryVariant,
        onPrimaryContainer: palette.onPrimary,
        secondary: palette.onCard,
        onSecondary: palette.onCard,
        secondaryContainer: palette.primaryVariant,
        onSecondaryContainer: palette.onPrimary,
        surface: palette.surface,
        onSurface: palette.onSurface,
        surfaceContainerHighest: palette.surface,
        onSurfaceVariant: palette.surface,
        error: palette.error,
        onError: palette.onError,
      ),
      cardColor: palette.card,
      scaffoldBackgroundColor: palette.surface,
      textTheme: _textTheme(palette),
      inputDecorationTheme: _inputDecorationTheme(palette),
      elevatedButtonTheme: _elevatedButtonTheme(palette),
      navigationBarTheme: _navigationBarTheme(palette),
      chipTheme: _chipTheme(palette),
      dividerTheme: _dividerTheme(palette),
      listTileTheme: _listTileTheme(palette),
      cardTheme: _cardTheme(palette),
    );
  }

  // ---------- helpers ----------

  static OutlineInputBorder _border(
    AppPalette palette, [
    Color? override,
  ]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: override ?? palette.primary,
          width: 2,
        ),
      );

  static TextTheme _textTheme(AppPalette p) => TextTheme(
        displayLarge: TextStyle(
          color: p.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 48,
        ),
        titleMedium: TextStyle(
          color: p.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: p.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: p.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: p.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
          color: p.onSurface,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      );

  static IconThemeData _iconTheme(AppPalette p) =>
      IconThemeData(color: p.onCard, size: 26);

  static InputDecorationTheme _inputDecorationTheme(AppPalette p) {
    final text = _textTheme(p);
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      border: _border(p),
      enabledBorder: _border(p),
      focusedBorder: _border(p, p.primary),
      errorBorder: _border(p, p.error),
      hintStyle: text.bodyMedium?.copyWith(
        color: p.onSurface.withValues(alpha: .5),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(AppPalette p) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          textStyle: _textTheme(p).bodyLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  static NavigationBarThemeData _navigationBarTheme(AppPalette p) {
    final text = _textTheme(p);
    final icon = _iconTheme(p);

    return NavigationBarThemeData(
      backgroundColor: p.surface,
      elevation: 0,
      indicatorColor: p.primary,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return text.bodySmall?.copyWith(
          color: selected ? p.primary : p.onCard,
          fontWeight: selected ? FontWeight.bold : FontWeight.w400,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return icon.copyWith(color: selected ? p.primary : icon.color);
      }),
    );
  }

  static ChipThemeData _chipTheme(AppPalette p) => ChipThemeData(
        color: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.primary : p.surface,
        ),
        labelStyle: _textTheme(p).bodyMedium!,
      );

  static DividerThemeData _dividerTheme(AppPalette p) => DividerThemeData(
        color: p.divider,
        indent: 16,
        endIndent: 16,
        thickness: 1,
        space: 0,
      );

  static ListTileThemeData _listTileTheme(AppPalette p) => ListTileThemeData(
        titleTextStyle: _textTheme(p).labelLarge,
        subtitleTextStyle: _textTheme(p).labelSmall,
      );

  static CardThemeData _cardTheme(AppPalette p) => CardThemeData(
        color: p.card, // белая карточка
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      );
}
