class AppConfig {
  static AppConfig? _instance;

  AppConfig._();

  static AppConfig get i {
    _instance ??= AppConfig._();
    return _instance!;
  }

  final String _appName = 'Codium';

  String get appName => _appName;
}
