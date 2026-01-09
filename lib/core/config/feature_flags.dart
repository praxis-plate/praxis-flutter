import 'package:flutter/foundation.dart';

class FeatureFlags {
  static const bool enableAiExplanations = false;
  static const bool enableAiChat = false;
  static const bool enableWebSearch = false;
  static const bool enableOfflineMode = true;
  static const bool enableCourses = true;
  static const bool enableProfile = true;

  static bool get isDebugMode => kDebugMode;
  static bool get enableLogging => isDebugMode;
}
