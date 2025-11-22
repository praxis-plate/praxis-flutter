import 'package:envied/envied.dart';

part 'env_config.g.dart';

@Envied(path: '.env')
abstract class EnvConfig {
  @EnviedField(varName: 'GEMINI_API_KEY', obfuscate: true)
  static final String geminiApiKey = _EnvConfig.geminiApiKey;

  @EnviedField(varName: 'SEARCH_API_KEY', obfuscate: true)
  static final String searchApiKey = _EnvConfig.searchApiKey;

  @EnviedField(varName: 'SEARCH_ENGINE_ID', obfuscate: true)
  static final String searchEngineId = _EnvConfig.searchEngineId;

  @EnviedField(varName: 'DB_PATH', obfuscate: false)
  static const String dbPath = _EnvConfig.dbPath;
}
