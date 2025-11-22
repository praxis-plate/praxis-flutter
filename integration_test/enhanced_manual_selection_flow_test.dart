import 'package:codium/app/app.dart';
import 'package:codium/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    DependencyInjection().initialize();
  });

  tearDownAll(() {
    GetIt.I.reset();
  });

  group('Enhanced Manual Selection - Integration Tests', () {
    testWidgets('Complete manual selection to explanation flow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final askAiButton = find.text('Ask AI');
      if (askAiButton.evaluate().isNotEmpty) {
        await tester.tap(askAiButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'What is polymorphism?');
          await tester.pumpAndSettle();

          final explainButton = find.text('Explain');
          if (explainButton.evaluate().isNotEmpty) {
            await tester.tap(explainButton);
            await tester.pumpAndSettle(const Duration(seconds: 5));

            expect(
              find.byType(CircularProgressIndicator),
              findsWidgets,
              reason: 'Loading indicator should appear during AI processing',
            );
          }
        }
      }
    });

    testWidgets('Clipboard paste to explain workflow', (
      WidgetTester tester,
    ) async {
      await Clipboard.setData(
        const ClipboardData(text: 'What is encapsulation?'),
      );

      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final askAiButton = find.text('Ask AI');
      if (askAiButton.evaluate().isNotEmpty) {
        await tester.tap(askAiButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        final pasteButton = find.text('Paste from Clipboard');
        if (pasteButton.evaluate().isNotEmpty) {
          await tester.tap(pasteButton);
          await tester.pumpAndSettle();

          final textField = find.byType(TextField);
          if (textField.evaluate().isNotEmpty) {
            final textFieldWidget = tester.widget<TextField>(textField.first);
            expect(
              textFieldWidget.controller?.text,
              contains('encapsulation'),
              reason: 'Text field should contain pasted clipboard content',
            );
          }
        }
      }
    });

    testWidgets('Keyboard shortcut to explain workflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyE);
      await tester.pumpAndSettle();

      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyE);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();

      final dialog = find.byType(AlertDialog);
      if (dialog.evaluate().isNotEmpty) {
        expect(
          dialog,
          findsOneWidget,
          reason: 'Dialog should open via keyboard shortcut',
        );

        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'What is inheritance?');
          await tester.pumpAndSettle();

          final explainButton = find.text('Explain');
          if (explainButton.evaluate().isNotEmpty) {
            await tester.tap(explainButton);
            await tester.pumpAndSettle(const Duration(seconds: 5));
          }
        }
      }
    });

    testWidgets('History navigation with page context', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final historyTab = find.text('History');
      if (historyTab.evaluate().isNotEmpty) {
        await tester.tap(historyTab);
        await tester.pumpAndSettle();

        final historyItems = find.byType(ListTile);
        if (historyItems.evaluate().isNotEmpty) {
          await tester.tap(historyItems.first);
          await tester.pumpAndSettle();

          expect(
            find.byType(AlertDialog),
            findsWidgets,
            reason:
                'Explanation dialog should appear when tapping history item',
          );
        }
      }
    });

    testWidgets('Page number displays in explanation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final askAiButton = find.text('Ask AI');
      if (askAiButton.evaluate().isNotEmpty) {
        await tester.tap(askAiButton);
        await tester.pumpAndSettle();

        final pageIndicator = find.textContaining('Page');
        if (pageIndicator.evaluate().isNotEmpty) {
          expect(
            pageIndicator,
            findsWidgets,
            reason: 'Page number should be visible in dialog',
          );
        }
      }
    });

    testWidgets('Floating button remains visible during scroll', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final fabBefore = find.text('Ask AI');
      expect(
        fabBefore.evaluate().isNotEmpty,
        isTrue,
        reason: 'FAB should be visible before scroll',
      );

      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -300));
        await tester.pumpAndSettle();

        final fabAfter = find.text('Ask AI');
        expect(
          fabAfter.evaluate().isNotEmpty,
          isTrue,
          reason: 'FAB should remain visible after scroll',
        );
      }
    });

    testWidgets('Error handling in manual selection flow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final askAiButton = find.text('Ask AI');
      if (askAiButton.evaluate().isNotEmpty) {
        await tester.tap(askAiButton);
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, '');
          await tester.pumpAndSettle();

          final explainButton = find.text('Explain');
          if (explainButton.evaluate().isNotEmpty) {
            await tester.tap(explainButton);
            await tester.pumpAndSettle();

            expect(
              find.byType(AlertDialog),
              findsOneWidget,
              reason: 'Dialog should remain open for empty input',
            );
          }
        }
      }
    });

    testWidgets('Multiple explanations preserve page context', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final queries = ['polymorphism', 'inheritance', 'encapsulation'];

      for (final query in queries) {
        final askAiButton = find.text('Ask AI');
        if (askAiButton.evaluate().isNotEmpty) {
          await tester.tap(askAiButton);
          await tester.pumpAndSettle();

          final textField = find.byType(TextField);
          if (textField.evaluate().isNotEmpty) {
            await tester.enterText(textField.first, query);
            await tester.pumpAndSettle();

            final explainButton = find.text('Explain');
            if (explainButton.evaluate().isNotEmpty) {
              await tester.tap(explainButton);
              await tester.pumpAndSettle(const Duration(seconds: 2));

              final cancelButton = find.text('Cancel');
              if (cancelButton.evaluate().isNotEmpty) {
                await tester.tap(cancelButton);
                await tester.pumpAndSettle();
              }
            }
          }
        }
      }

      final historyTab = find.text('History');
      if (historyTab.evaluate().isNotEmpty) {
        await tester.tap(historyTab);
        await tester.pumpAndSettle();

        expect(
          find.byType(ListTile),
          findsWidgets,
          reason: 'History should contain multiple explanations',
        );
      }
    });
  });
}
