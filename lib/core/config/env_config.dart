import 'package:envied/envied.dart';

part 'env_config.g.dart';

@Envied(path: '.env')
abstract class EnvConfig {
  @EnviedField(varName: 'GEMINI_API_KEY', obfuscate: true)
  static final String geminiApiKey = _EnvConfig.geminiApiKey;

  @EnviedField(varName: 'DB_PATH', obfuscate: false)
  static const String dbPath = _EnvConfig.dbPath;

  @EnviedField(varName: 'PROXY_HOST', obfuscate: false)
  static const String proxyHost = _EnvConfig.proxyHost;

  @EnviedField(varName: 'PROXY_PORT', obfuscate: false)
  static const String proxyPort = _EnvConfig.proxyPort;

  @EnviedField(varName: 'PROXY_USER', obfuscate: true)
  static final String proxyUser = _EnvConfig.proxyUser;

  @EnviedField(varName: 'PROXY_PASS', obfuscate: true)
  static final String proxyPass = _EnvConfig.proxyPass;
}
