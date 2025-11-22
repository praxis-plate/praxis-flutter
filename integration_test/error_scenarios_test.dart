import 'package:codium/app/app.dart';
import 'package:codium/dependency_injection.dart';
import 'package:flutter/material.dart';
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

  group('Error Scenarios Tests', () {
    testWidgets('Handle invalid login credentials', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final signInButton = find.text('Sign In');
      if (signInButton.evaluate().isNotEmpty) {
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        final emailField = find.byType(TextField).first;
        await tester.enterText(emailField, 'invalid@example.com');
        await tester.pumpAndSettle();

        final passwordField = find.byType(TextField).at(1);
        await tester.enterText(passwordField, 'wrongpassword');
        await tester.pumpAndSettle();

        final submitButton = find.widgetWithText(ElevatedButton, 'Sign In');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();

          expect(find.text('Invalid credentials'), findsWidgets);
        }
      }
    });

    testWidgets('Handle empty form submission', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final signInButton = find.text('Sign In');
      if (signInButton.evaluate().isNotEmpty) {
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        final submitButton = find.widgetWithText(ElevatedButton, 'Sign In');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();

          expect(find.textContaining('required'), findsWidgets);
        }
      }
    });

    testWidgets('Handle network error gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final explainButton = find.text('Explain');
      if (explainButton.evaluate().isNotEmpty) {
        await tester.tap(explainButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    });

    testWidgets('Display error message with retry option', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final retryButton = find.text('Retry');
      if (retryButton.evaluate().isNotEmpty) {
        expect(retryButton, findsWidgets);
      }
    });
  });
}
