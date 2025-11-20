import 'package:codium/core/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenSize', () {
    testWidgets('getDeviceType returns mobile for small screens', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final deviceType = ScreenSize.getDeviceType(context);
                expect(deviceType, DeviceType.mobile);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getDeviceType returns tablet for medium screens', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 1024)),
            child: Builder(
              builder: (context) {
                final deviceType = ScreenSize.getDeviceType(context);
                expect(deviceType, DeviceType.tablet);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getDeviceType returns desktop for large screens', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: Builder(
              builder: (context) {
                final deviceType = ScreenSize.getDeviceType(context);
                expect(deviceType, DeviceType.desktop);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('isMobile returns true for mobile screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                expect(ScreenSize.isMobile(context), true);
                expect(ScreenSize.isTablet(context), false);
                expect(ScreenSize.isDesktop(context), false);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getOrientation returns correct orientation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                expect(ScreenSize.isPortrait(context), true);
                expect(ScreenSize.isLandscape(context), false);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getResponsiveValue returns correct value for device type', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final value = ScreenSize.getResponsiveValue<int>(
                  context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                );
                expect(value, 1);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getMaxContentWidth returns correct width for device type', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: Builder(
              builder: (context) {
                final maxWidth = ScreenSize.getMaxContentWidth(context);
                expect(maxWidth, 1200);
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });
}
