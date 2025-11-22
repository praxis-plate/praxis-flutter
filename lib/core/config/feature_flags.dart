import 'package:flutter/foundation.dart';

class FeatureFlags {
  static const bool enableAiExplanations = false;
  static const bool enableAiChat = false;
  static const bool enableWebSearch = false;
  static const bool enableBookmarks = true;
  static const bool enableExplanationHistory = true;
  static const bool enableOfflineMode = true;
  static const bool enableCourses = false;
  static const bool enableProfile = false;
  static const bool enableOnboarding = false;

  static bool get isDebugMode => kDebugMode;
  static bool get enableLogging => isDebugMode;
}
