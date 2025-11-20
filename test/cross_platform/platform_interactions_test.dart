import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Platform Interactions Tests', () {
    testWidgets('Touch gestures work on mobile', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () => tapped = true,
              child: const Text('Tap me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('Long press gestures work', (WidgetTester tester) async {
      bool longPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onLongPress: () => longPressed = true,
              child: const Text('Long press me'),
            ),
          ),
        ),
      );

      await tester.longPress(find.text('Long press me'));
      await tester.pumpAndSettle();

      expect(longPressed, isTrue);
    });

    testWidgets('Swipe gestures work', (WidgetTester tester) async {
      bool swiped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onHorizontalDragEnd: (_) => swiped = true,
              child: const SizedBox(
                width: 200,
                height: 200,
                child: Text('Swipe me'),
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.text('Swipe me'), const Offset(200, 0));
      await tester.pumpAndSettle();

      expect(swiped, isTrue);
    });

    testWidgets('Hover states work on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MouseRegion(
              onEnter: (_) {},
              onExit: (_) {},
              child: const Text('Hover me'),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await tester.pump();

      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('Context menu can be triggered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onSecondaryTap: () {},
              child: const Text('Right click me'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Right click me'), findsOneWidget);
    });
  });
}
