import 'package:codium/core/widgets/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveLayout', () {
    testWidgets('displays mobile widget on mobile screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: AdaptiveLayout(
              mobile: Text('Mobile'),
              tablet: Text('Tablet'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('displays tablet widget on tablet screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 1024)),
            child: AdaptiveLayout(
              mobile: Text('Mobile'),
              tablet: Text('Tablet'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('displays desktop widget on desktop screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: AdaptiveLayout(
              mobile: Text('Mobile'),
              tablet: Text('Tablet'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets('falls back to mobile when tablet not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 1024)),
            child: AdaptiveLayout(
              mobile: Text('Mobile'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);
    });
  });

  group('AdaptiveContainer', () {
    testWidgets('applies correct padding for mobile', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: AdaptiveContainer(
              mobilePadding: EdgeInsets.all(16),
              tabletPadding: EdgeInsets.all(24),
              desktopPadding: EdgeInsets.all(32),
              child: Text('Content'),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.all(16));
    });

    testWidgets('applies max width constraint on desktop', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: AdaptiveContainer(
              desktopMaxWidth: 1200,
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(ConstrainedBox), findsWidgets);
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      final hasMaxWidth = constrainedBoxes.any(
        (box) => box.constraints.maxWidth == 1200,
      );
      expect(hasMaxWidth, true);
    });
  });

  group('AdaptiveGrid', () {
    testWidgets('displays correct number of columns for mobile', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: AdaptiveGrid(
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 3,
              children: List.generate(6, (i) => Text('Item $i')),
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.textContaining('Item'), findsNWidgets(6));
    });
  });
}
