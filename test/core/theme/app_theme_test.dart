import 'package:codium/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('light theme has correct colors', () {
      final theme = AppTheme.of(Brightness.light);

      expect(theme.brightness, Brightness.light);
      expect(
        theme.colorScheme.primary,
        const Color.fromARGB(255, 43, 230, 188),
      );
      expect(
        theme.colorScheme.surface,
        const Color.fromARGB(255, 250, 250, 250),
      );
      expect(
        theme.colorScheme.onSurface,
        const Color.fromARGB(255, 33, 33, 33),
      );
      expect(theme.colorScheme.error, const Color.fromARGB(255, 211, 47, 47));
    });

    test('dark theme has correct colors', () {
      final theme = AppTheme.of(Brightness.dark);

      expect(theme.brightness, Brightness.dark);
      expect(
        theme.colorScheme.primary,
        const Color.fromARGB(255, 43, 230, 188),
      );
      expect(theme.colorScheme.surface, const Color.fromARGB(255, 13, 17, 23));
      expect(
        theme.colorScheme.onSurface,
        const Color.fromARGB(255, 230, 237, 243),
      );
      expect(theme.colorScheme.error, const Color.fromARGB(255, 248, 81, 73));
    });

    test('light theme has no pink colors', () {
      final theme = AppTheme.of(Brightness.light);

      expect(theme.colorScheme.primary, isNot(contains('pink')));
      expect(
        theme.colorScheme.primaryContainer,
        isNot(const Color.fromARGB(255, 230, 43, 85)),
      );
    });

    test('dark theme has no pink colors', () {
      final theme = AppTheme.of(Brightness.dark);

      expect(theme.colorScheme.primary, isNot(contains('pink')));
      expect(
        theme.colorScheme.primaryContainer,
        isNot(const Color.fromARGB(255, 230, 43, 85)),
      );
    });

    test('light theme has proper contrast for text', () {
      final theme = AppTheme.of(Brightness.light);
      final surface = theme.colorScheme.surface;
      final onSurface = theme.colorScheme.onSurface;

      final surfaceLuminance = surface.computeLuminance();
      final onSurfaceLuminance = onSurface.computeLuminance();

      final contrastRatio = (surfaceLuminance > onSurfaceLuminance)
          ? (surfaceLuminance + 0.05) / (onSurfaceLuminance + 0.05)
          : (onSurfaceLuminance + 0.05) / (surfaceLuminance + 0.05);

      expect(contrastRatio, greaterThan(4.5));
    });

    test('dark theme has proper contrast for text', () {
      final theme = AppTheme.of(Brightness.dark);
      final surface = theme.colorScheme.surface;
      final onSurface = theme.colorScheme.onSurface;

      final surfaceLuminance = surface.computeLuminance();
      final onSurfaceLuminance = onSurface.computeLuminance();

      final contrastRatio = (surfaceLuminance > onSurfaceLuminance)
          ? (surfaceLuminance + 0.05) / (onSurfaceLuminance + 0.05)
          : (onSurfaceLuminance + 0.05) / (surfaceLuminance + 0.05);

      expect(contrastRatio, greaterThan(4.5));
    });

    test('card colors have proper contrast in light theme', () {
      final theme = AppTheme.of(Brightness.light);
      final card = theme.cardColor;
      final onCard = AppPalette.light.onCard;

      final cardLuminance = card.computeLuminance();
      final onCardLuminance = onCard.computeLuminance();

      final contrastRatio = (cardLuminance > onCardLuminance)
          ? (cardLuminance + 0.05) / (onCardLuminance + 0.05)
          : (onCardLuminance + 0.05) / (cardLuminance + 0.05);

      expect(contrastRatio, greaterThan(3.0));
    });

    test('card colors have proper contrast in dark theme', () {
      final theme = AppTheme.of(Brightness.dark);
      final card = theme.cardColor;
      final onCard = AppPalette.dark.onCard;

      final cardLuminance = card.computeLuminance();
      final onCardLuminance = onCard.computeLuminance();

      final contrastRatio = (cardLuminance > onCardLuminance)
          ? (cardLuminance + 0.05) / (onCardLuminance + 0.05)
          : (onCardLuminance + 0.05) / (cardLuminance + 0.05);

      expect(contrastRatio, greaterThan(3.0));
    });

    test('input text has proper contrast in light theme', () {
      final theme = AppTheme.of(Brightness.light);
      final surface = theme.colorScheme.surface;
      final textColor = theme.textTheme.bodyMedium!.color!;

      final surfaceLuminance = surface.computeLuminance();
      final textLuminance = textColor.computeLuminance();

      final contrastRatio = (surfaceLuminance > textLuminance)
          ? (surfaceLuminance + 0.05) / (textLuminance + 0.05)
          : (textLuminance + 0.05) / (surfaceLuminance + 0.05);

      expect(contrastRatio, greaterThan(4.5));
    });

    test('input text has proper contrast in dark theme', () {
      final theme = AppTheme.of(Brightness.dark);
      final surface = theme.colorScheme.surface;
      final textColor = theme.textTheme.bodyMedium!.color!;

      final surfaceLuminance = surface.computeLuminance();
      final textLuminance = textColor.computeLuminance();

      final contrastRatio = (surfaceLuminance > textLuminance)
          ? (surfaceLuminance + 0.05) / (textLuminance + 0.05)
          : (textLuminance + 0.05) / (surfaceLuminance + 0.05);

      expect(contrastRatio, greaterThan(4.5));
    });

    test('input label has proper color in dark theme', () {
      final theme = AppTheme.of(Brightness.dark);
      final labelColor = theme.inputDecorationTheme.labelStyle!.color!;
      final expectedColor = AppPalette.dark.onSurface;

      expect(labelColor, expectedColor);
    });

    test('input label has proper color in light theme', () {
      final theme = AppTheme.of(Brightness.light);
      final labelColor = theme.inputDecorationTheme.labelStyle!.color!;
      final expectedColor = AppPalette.light.onSurface;

      expect(labelColor, expectedColor);
    });
  });
}
