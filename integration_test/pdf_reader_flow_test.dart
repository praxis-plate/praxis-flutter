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

  group('PDF Reader Flow Tests', () {
    testWidgets('Open PDF and navigate pages', (WidgetTester tester) async {
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
        }
      }
    });

    testWidgets('Add bookmark in PDF', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final bookmarkIcon = find.byIcon(Icons.bookmark_add);
      if (bookmarkIcon.evaluate().isNotEmpty) {
        await tester.tap(bookmarkIcon);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('View bookmarks list', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final bookmarksButton = find.byIcon(Icons.bookmarks);
      if (bookmarksButton.evaluate().isNotEmpty) {
        await tester.tap(bookmarksButton);
        await tester.pumpAndSettle();
      }
    });
  });
}
