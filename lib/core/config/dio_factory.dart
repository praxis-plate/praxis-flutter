import 'dart:io';

import 'package:codium/core/config/env_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioFactory {
  DioFactory._();

  static Dio createGeminiDio() {
    final dio = Dio();

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (uri) {
          return 'PROXY ${EnvConfig.proxyUser}:${EnvConfig.proxyPass}@${EnvConfig.proxyHost}:${EnvConfig.proxyPort}';
        };
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    return dio;
  }

  static Dio createDefaultDio() {
    return Dio();
  }
}
