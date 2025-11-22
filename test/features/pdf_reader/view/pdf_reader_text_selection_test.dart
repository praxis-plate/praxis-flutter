import 'package:codium/features/pdf_reader/widgets/text_selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PDF Reader Text Selection - Property Tests', () {
    testWidgets(
      'Feature: codium-ai-enhancement, Property 2: Text Selection Shows Context Menu - '
      'For any text selection in a PDF, the system should display a context menu '
      'containing an "Explain" option',
      (WidgetTester tester) async {
        final testCases = _generatePropertyTestCases(100);

        for (final testCase in testCases) {
          bool explainCalled = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TextSelectionMenu(
                  selectedText: testCase.selectedText,
                  onExplain: () {
                    explainCalled = true;
                  },
                  onDismiss: () {},
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(
            find.byType(TextSelectionMenu),
            findsOneWidget,
            reason:
                'Context menu should be displayed for selected text: '
                '"${testCase.selectedText}"',
          );

          final menu = tester.widget<TextSelectionMenu>(
            find.byType(TextSelectionMenu),
          );

          expect(
            menu.selectedText,
            equals(testCase.selectedText),
            reason: 'Selected text should match the input',
          );

          expect(
            menu.selectedText,
            isNotEmpty,
            reason: 'Selected text should not be empty',
          );

          expect(
            find.descendant(
              of: find.byType(TextSelectionMenu),
              matching: find.byIcon(Icons.lightbulb_outline),
            ),
            findsOneWidget,
            reason:
                'Context menu should contain an "Explain" button '
                'for selected text: "${testCase.selectedText}"',
          );

          final explainButton = find.descendant(
            of: find.byType(TextSelectionMenu),
            matching: find.byIcon(Icons.lightbulb_outline),
          );

          await tester.tap(explainButton);
          await tester.pumpAndSettle();

          expect(
            explainCalled,
            isTrue,
            reason:
                'Tapping the Explain button should trigger the onExplain callback',
          );

          expect(
            find.descendant(
              of: find.byType(TextSelectionMenu),
              matching: find.byType(IconButton),
            ),
            findsAtLeastNWidgets(1),
            reason: 'Context menu should have at least one interactive button',
          );
        }
      },
    );
  });
}

class _PropertyTestCase {
  _PropertyTestCase({required this.selectedText});

  final String selectedText;
}

List<_PropertyTestCase> _generatePropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <_PropertyTestCase>[];

  final sampleTexts = [
    'variable',
    'function',
    'class definition',
    'interface implementation',
    'async/await pattern',
    'callback function',
    'closure concept',
    'recursion algorithm',
    'data structure',
    'polymorphism',
    'inheritance hierarchy',
    'encapsulation principle',
    'abstraction layer',
    'dependency injection',
    'design pattern',
    'singleton pattern',
    'factory method',
    'observer pattern',
    'strategy pattern',
    'decorator pattern',
    'adapter pattern',
    'facade pattern',
    'proxy pattern',
    'iterator pattern',
    'composite pattern',
    'command pattern',
    'state pattern',
    'template method',
    'visitor pattern',
    'chain of responsibility',
    'mediator pattern',
    'memento pattern',
    'prototype pattern',
    'builder pattern',
    'bridge pattern',
    'flyweight pattern',
    'null safety',
    'type inference',
    'generic types',
    'extension methods',
  ];

  for (var i = 0; i < count; i++) {
    final textIndex = (random + i * 7) % sampleTexts.length;

    cases.add(_PropertyTestCase(selectedText: sampleTexts[textIndex]));
  }

  return cases;
}
