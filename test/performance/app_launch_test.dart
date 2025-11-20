import 'package:codium/app/app.dart';
import 'package:codium/dependency_injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Launch Performance Tests', () {
    setUpAll(() {
      DependencyInjection().initialize();
    });

    testWidgets('App launches within 2 seconds', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      stopwatch.stop();

      final launchTime = stopwatch.elapsedMilliseconds;
      print('App launch time: ${launchTime}ms');

      expect(
        launchTime,
        lessThan(2000),
        reason: 'App should launch within 2 seconds (2000ms)',
      );
    });

    testWidgets('Initial frame renders quickly', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const App());
      await tester.pump();

      stopwatch.stop();

      final firstFrameTime = stopwatch.elapsedMilliseconds;
      print('First frame render time: ${firstFrameTime}ms');

      expect(
        firstFrameTime,
        lessThan(500),
        reason: 'First frame should render within 500ms',
      );
    });
  });
}
