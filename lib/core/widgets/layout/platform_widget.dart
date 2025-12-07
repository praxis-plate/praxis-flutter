import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? android;
  final Widget? ios;
  final Widget? windows;
  final Widget? macos;
  final Widget? linux;
  final Widget? web;
  final Widget fallback;

  const PlatformWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.android,
    this.ios,
    this.windows,
    this.macos,
    this.linux,
    this.web,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return web ?? fallback;
    }

    if (Platform.isAndroid) {
      return android ?? mobile ?? fallback;
    }

    if (Platform.isIOS) {
      return ios ?? mobile ?? fallback;
    }

    if (Platform.isWindows) {
      return windows ?? desktop ?? fallback;
    }

    if (Platform.isMacOS) {
      return macos ?? desktop ?? fallback;
    }

    if (Platform.isLinux) {
      return linux ?? desktop ?? fallback;
    }

    return fallback;
  }
}

class PlatformInfo {
  static bool get isMobilePlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool get isDesktopPlatform {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  static bool get isMacOS {
    if (kIsWeb) return false;
    return Platform.isMacOS;
  }

  static bool get isLinux {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }

  static bool get isWeb {
    return kIsWeb;
  }

  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}
