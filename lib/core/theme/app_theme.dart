import 'package:flutter/material.dart';

@immutable
class AppPalette {
  static const Color star = Color.fromARGB(255, 255, 193, 7);

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
    primaryVariant: Color.fromARGB(255, 30, 180, 150),
    card: Color.fromARGB(255, 22, 27, 34),
    onSurface: Color.fromARGB(255, 230, 237, 243),
    onCard: Color.fromARGB(255, 139, 148, 158),
    divider: Color.fromARGB(255, 48, 54, 61),
    onPrimary: Color.fromARGB(255, 13, 17, 23),
    surface: Color.fromARGB(255, 13, 17, 23),
    error: Color.fromARGB(255, 248, 81, 73),
    onError: Color.fromARGB(255, 255, 255, 255),
  );

  static const light = AppPalette(
    primary: Color.fromARGB(255, 16, 185, 129),
    primaryVariant: Color.fromARGB(255, 5, 150, 105),
    card: Color.fromARGB(255, 245, 245, 247),
    onSurface: Color.fromARGB(255, 33, 33, 33),
    onCard: Color.fromARGB(255, 66, 66, 66),
    divider: Color.fromARGB(255, 224, 224, 224),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    surface: Color.fromARGB(255, 238, 238, 240),
    error: Color.fromARGB(255, 211, 47, 47),
    onError: Color.fromARGB(255, 255, 255, 255),
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData of(Brightness brightness) {
    final palette = brightness == Brightness.dark
        ? AppPalette.dark
        : AppPalette.light;

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
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.primary,
        selectionColor: palette.primary.withValues(alpha: 0.3),
        selectionHandleColor: palette.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) =>
            const Icon(Icons.arrow_back_ios_rounded),
      ),
      elevatedButtonTheme: _elevatedButtonTheme(palette),
      navigationBarTheme: _navigationBarTheme(palette),
      tabBarTheme: _tabBarTheme(palette),
      chipTheme: _chipTheme(palette),
      dividerTheme: _dividerTheme(palette),
      listTileTheme: _listTileTheme(palette),
      cardTheme: _cardTheme(palette),
    );
  }

  // ---------- helpers ----------

  static OutlineInputBorder _border(AppPalette palette, [Color? override]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: override ?? palette.primary, width: 2),
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
    final neutralBorderColor = p.onSurface.withValues(alpha: 0.3);

    return InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: p.card.withValues(alpha: 0.92),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      constraints: const BoxConstraints(minHeight: 60),
      border: _border(p, neutralBorderColor),
      enabledBorder: _border(p, neutralBorderColor),
      focusedBorder: _border(p, p.primary),
      errorBorder: _border(p, p.error),
      focusedErrorBorder: _border(p, p.error),
      labelStyle: TextStyle(color: p.onSurface.withValues(alpha: 0.6)),
      floatingLabelStyle: TextStyle(color: p.primary),
      hintStyle: text.bodyMedium?.copyWith(
        color: p.onSurface.withValues(alpha: 0.4),
      ),
      prefixIconColor: p.onSurface.withValues(alpha: 0.7),
      suffixIconColor: p.onSurface.withValues(alpha: 0.7),
      suffixIconConstraints: const BoxConstraints(minWidth: 50, minHeight: 50),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(AppPalette p) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          minimumSize: const Size(0, 46),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

  static NavigationBarThemeData _navigationBarTheme(AppPalette p) {
    final text = _textTheme(p);
    final icon = _iconTheme(p);

    return NavigationBarThemeData(
      backgroundColor: p.card,
      elevation: 0,
      indicatorColor: p.primary.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return text.bodySmall?.copyWith(
          color: selected ? p.primary : p.onSurface.withValues(alpha: 0.6),
          fontWeight: selected ? FontWeight.bold : FontWeight.w400,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return icon.copyWith(
          color: selected ? p.primary : p.onSurface.withValues(alpha: 0.6),
        );
      }),
    );
  }

  static TabBarThemeData _tabBarTheme(AppPalette p) {
    final text = _textTheme(p);

    return TabBarThemeData(
      labelColor: p.primary,
      unselectedLabelColor: p.onSurface.withValues(alpha: 0.6),
      labelStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: text.bodyMedium?.copyWith(
        fontWeight: FontWeight.normal,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: p.primary, width: 3),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
    );
  }

  static ChipThemeData _chipTheme(AppPalette p) => ChipThemeData(
    color: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected) ? p.primary : p.surface,
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
    iconColor: p.onSurface,
    leadingAndTrailingTextStyle: _textTheme(p).bodyMedium,
  );

  static CardThemeData _cardTheme(AppPalette p) => CardThemeData(
    color: p.card, // белая карточка
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}
