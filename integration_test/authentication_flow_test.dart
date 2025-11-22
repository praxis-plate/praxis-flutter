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

  group('Authentication Flow Tests', () {
    testWidgets('Complete sign up flow', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final signUpButton = find.text('Sign Up');
      if (signUpButton.evaluate().isNotEmpty) {
        await tester.tap(signUpButton);
        await tester.pumpAndSettle();

        final emailField = find.byType(TextField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pumpAndSettle();

        final passwordField = find.byType(TextField).at(1);
        await tester.enterText(passwordField, 'password123');
        await tester.pumpAndSettle();

        final submitButton = find.widgetWithText(ElevatedButton, 'Sign Up');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Complete sign in flow', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final signInButton = find.text('Sign In');
      if (signInButton.evaluate().isNotEmpty) {
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        final emailField = find.byType(TextField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pumpAndSettle();

        final passwordField = find.byType(TextField).at(1);
        await tester.enterText(passwordField, 'password123');
        await tester.pumpAndSettle();

        final submitButton = find.widgetWithText(ElevatedButton, 'Sign In');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Sign out flow', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final signOutButton = find.text('Sign Out');
      if (signOutButton.evaluate().isNotEmpty) {
        await tester.tap(signOutButton);
        await tester.pumpAndSettle();
      }
    });
  });
}
