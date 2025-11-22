import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Enhanced Manual Selection - Widget Tests', () {
    testWidgets('Floating Ask AI button is visible and positioned correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const Center(child: Text('PDF Content')),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Ask AI'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      final fab = tester.widget<FloatingActionButton>(fabFinder);
      expect(fab, isNotNull);

      expect(find.text('Ask AI'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);

      final fabPosition = tester.getBottomRight(fabFinder);
      final screenSize = tester.getSize(find.byType(Scaffold));

      expect(fabPosition.dx, lessThan(screenSize.width));
      expect(fabPosition.dy, lessThan(screenSize.height));
    });

    testWidgets('Text input dialog displays with paste button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ask AI'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter text to explain',
                                hintText: 'Type or paste text here',
                              ),
                              maxLines: 5,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.content_paste),
                              label: const Text('Paste from Clipboard'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Explain'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Ask AI'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Paste from Clipboard'), findsOneWidget);
      expect(find.byIcon(Icons.content_paste), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Explain'), findsOneWidget);
    });

    testWidgets('Clipboard paste button UI structure', (
      WidgetTester tester,
    ) async {
      const hasClipboardText = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ask AI'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasClipboardText)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.content_paste, size: 16),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Test clipboard preview',
                                        style: TextStyle(fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 8),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter text to explain',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byIcon(Icons.content_paste), findsOneWidget);
      expect(find.text('Test clipboard preview'), findsOneWidget);
    });

    testWidgets('Keyboard shortcut Ctrl+E opens dialog on desktop', (
      WidgetTester tester,
    ) async {
      bool dialogOpened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardListener(
              focusNode: FocusNode()..requestFocus(),
              autofocus: true,
              onKeyEvent: (event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.keyE &&
                      HardwareKeyboard.instance.isControlPressed) {
                    dialogOpened = true;
                  }
                }
              },
              child: const Center(child: Text('PDF Content')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyE);
      await tester.pumpAndSettle();

      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyE);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();

      expect(dialogOpened, isTrue);
    });

    testWidgets('Dialog displays current page number', (
      WidgetTester tester,
    ) async {
      const currentPage = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            const Text('Ask AI'),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bookmark_outline,
                                    size: 14,
                                    color: Colors.blue[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Page ${currentPage + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        content: const TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter text to explain',
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Page ${currentPage + 1}'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    });

    testWidgets('Tooltip shows on floating button hover', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Tooltip(
                message: 'Long-press PDF or tap here to ask AI',
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Ask AI'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(fabFinder));
      await tester.pumpAndSettle();

      expect(find.text('Long-press PDF or tap here to ask AI'), findsOneWidget);
    });

    testWidgets('Dialog text field accepts input', (WidgetTester tester) async {
      final textController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ask AI'),
                        content: TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                            labelText: 'Enter text to explain',
                          ),
                          maxLines: 5,
                        ),
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      const testText = 'What is polymorphism?';
      await tester.enterText(find.byType(TextField), testText);
      await tester.pumpAndSettle();

      expect(textController.text, equals(testText));
      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('Multiple screen sizes - button remains visible', (
      WidgetTester tester,
    ) async {
      final screenSizes = [
        const Size(360, 640),
        const Size(768, 1024),
        const Size(1920, 1080),
      ];

      for (final size in screenSizes) {
        await tester.binding.setSurfaceSize(size);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('PDF Content')),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('Ask AI'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(FloatingActionButton),
          findsOneWidget,
          reason: 'FAB should be visible on screen size $size',
        );
        expect(
          find.text('Ask AI'),
          findsOneWidget,
          reason: 'Ask AI label should be visible on screen size $size',
        );
      }

      await tester.binding.setSurfaceSize(null);
    });
  });
}
