import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Platform-Specific Features Tests', () {
    test('Detect current platform', () {
      if (Platform.isAndroid) {
        print('Running on Android');
        expect(Platform.isAndroid, isTrue);
      } else if (Platform.isIOS) {
        print('Running on iOS');
        expect(Platform.isIOS, isTrue);
      } else if (Platform.isWindows) {
        print('Running on Windows');
        expect(Platform.isWindows, isTrue);
      } else if (Platform.isMacOS) {
        print('Running on macOS');
        expect(Platform.isMacOS, isTrue);
      } else if (Platform.isLinux) {
        print('Running on Linux');
        expect(Platform.isLinux, isTrue);
      }
    });

    test('Platform has correct path separator', () {
      if (Platform.isWindows) {
        expect(Platform.pathSeparator, equals('\\'));
      } else {
        expect(Platform.pathSeparator, equals('/'));
      }
    });

    test('Platform environment variables are accessible', () {
      final env = Platform.environment;
      expect(env, isNotEmpty);
      print('Environment variables count: ${env.length}');
    });

    test('Platform supports required features', () {
      expect(Platform.numberOfProcessors, greaterThan(0));
      print('Number of processors: ${Platform.numberOfProcessors}');
    });
  });
}
