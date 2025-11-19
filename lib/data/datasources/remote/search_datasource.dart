import 'package:codium/core/config/env_config.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:dio/dio.dart';

class SearchDataSource {
  SearchDataSource() : _dio = _initializeDio();

  static Dio _initializeDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.googleapis.com/customsearch/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    return dio;
  }

  final Dio _dio;

  Future<List<SearchSource>> searchWeb(String query) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'key': EnvConfig.searchApiKey,
          'cx': EnvConfig.searchEngineId,
          'q': query,
          'num': 3,
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Search API returned status ${response.statusCode}',
        );
      }

      final items = response.data['items'] as List<dynamic>?;

      if (items == null || items.isEmpty) {
        return [];
      }

      return items.map((item) => _parseSearchResult(item)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw DioException(
          requestOptions: e.requestOptions,
          type: DioExceptionType.connectionTimeout,
          message: 'Search request timed out',
        );
      }
      if (e.response?.statusCode == 429) {
        throw DioException(
          requestOptions: e.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Search API rate limit exceeded',
        );
      }
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.unknown,
        message: 'Failed to parse search results: $e',
      );
    }
  }

  SearchSource _parseSearchResult(dynamic item) {
    final title = item['title'] as String? ?? 'No title';
    final snippet = item['snippet'] as String? ?? 'No description available';
    final url = item['link'] as String? ?? '';

    return SearchSource(title: title, snippet: snippet, url: url);
  }
}
