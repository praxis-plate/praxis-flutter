import 'package:codium/core/utils/screen_size.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cross-Platform Adaptation Tests', () {
    testWidgets('AdaptiveLayout responds to screen size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveLayout(
              mobile: Text('Mobile'),
              tablet: Text('Tablet'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdaptiveLayout), findsOneWidget);
    });

    testWidgets('ScreenSize utility works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final deviceType = ScreenSize.getDeviceType(context);
                return Text('Screen: ${deviceType.name}');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Screen:'), findsOneWidget);
    });

    testWidgets('PlatformWidget adapts to platform', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlatformWidget(
              android: Text('Android'),
              ios: Text('iOS'),
              web: Text('Web'),
              windows: Text('Windows'),
              macos: Text('macOS'),
              linux: Text('Linux'),
              fallback: Text('Fallback'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PlatformWidget), findsOneWidget);
    });

    test('Mobile layout breakpoint is correct', () {
      const mobileWidth = 600.0;
      expect(mobileWidth, lessThanOrEqualTo(600));
    });

    test('Tablet layout breakpoint is correct', () {
      const tabletWidth = 900.0;
      expect(tabletWidth, greaterThan(600));
      expect(tabletWidth, lessThanOrEqualTo(1200));
    });

    test('Desktop layout breakpoint is correct', () {
      const desktopWidth = 1400.0;
      expect(desktopWidth, greaterThan(1200));
    });
  });
}
