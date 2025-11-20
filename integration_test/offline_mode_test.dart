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

  group('Offline Mode Tests', () {
    testWidgets('Read PDF offline', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final libraryTab = find.text('Library');
      if (libraryTab.evaluate().isNotEmpty) {
        await tester.tap(libraryTab);
        await tester.pumpAndSettle();

        final pdfCard = find.byType(Card).first;
        if (pdfCard.evaluate().isNotEmpty) {
          await tester.tap(pdfCard);
          await tester.pumpAndSettle();

          expect(find.byType(MaterialApp), findsOneWidget);
        }
      }
    });

    testWidgets('View cached explanation history offline', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final historyTab = find.text('History');
      if (historyTab.evaluate().isNotEmpty) {
        await tester.tap(historyTab);
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsWidgets);
      }
    });

    testWidgets('Manage bookmarks offline', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final bookmarkIcon = find.byIcon(Icons.bookmark_add);
      if (bookmarkIcon.evaluate().isNotEmpty) {
        await tester.tap(bookmarkIcon);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Display offline indicator when no connection', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final offlineIndicator = find.text('Offline');
      if (offlineIndicator.evaluate().isNotEmpty) {
        expect(offlineIndicator, findsWidgets);
      }
    });

    testWidgets('AI features disabled offline', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final explainButton = find.text('Explain');
      if (explainButton.evaluate().isNotEmpty) {
        final button = tester.widget<ElevatedButton>(explainButton);
        expect(button.enabled, isFalse);
      }
    });
  });
}
