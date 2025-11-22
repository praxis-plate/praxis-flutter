import 'package:codium/core/exceptions/exceptions.dart';
import 'package:codium/domain/datasources/i_gemini_datasource.dart';
import 'package:codium/domain/datasources/i_search_datasource.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/domain/repositories/ai_repository.dart';
import 'package:codium/domain/services/services.dart';
import 'package:dio/dio.dart';

class AiRepository implements IAiRepository {
  AiRepository({
    required IGeminiDataSource geminiDataSource,
    required ISearchDataSource searchDataSource,
    required IConnectivityService connectivityService,
  }) : _geminiDataSource = geminiDataSource,
       _searchDataSource = searchDataSource,
       _connectivityService = connectivityService;

  final IGeminiDataSource _geminiDataSource;
  final ISearchDataSource _searchDataSource;
  final IConnectivityService _connectivityService;

  @override
  Future<String> explainText({
    required String text,
    required String context,
  }) async {
    if (!_connectivityService.isConnected) {
      throw const NetworkError.noInternet(
        message: 'No internet connection. AI features require internet access.',
      );
    }

    try {
      final explanation = await _geminiDataSource.explainText(
        text: text,
        context: context,
      );

      return explanation;
    } on GeminiRateLimitException {
      throw const RateLimitError(
        message:
            'AI service is temporarily unavailable due to rate limits. Please try again in a few moments.',
      );
    } on GeminiInvalidApiKeyException {
      throw const UnknownError(
        message: 'Invalid API key configuration. Please contact support.',
      );
    } on GeminiModelNotAvailableException {
      throw const UnknownError(
        message: 'AI model is currently unavailable. Please try again later.',
      );
    } on GeminiEmptyResponseException {
      throw const UnknownError(
        message: 'AI service returned an empty response. Please try again.',
      );
    } on GeminiException catch (e) {
      throw UnknownError(message: 'AI explanation failed: ${e.message}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkError.noInternet(
          message:
              'No internet connection. AI features require internet access.',
        );
      }
      throw NetworkError.general(
        message: 'Failed to generate explanation: ${e.message}',
      );
    } catch (e) {
      throw const UnknownError(
        message: 'Unexpected error while generating explanation',
      );
    }
  }

  @override
  Future<List<SearchSource>> searchWeb(String query) async {
    if (!_connectivityService.isConnected) {
      return [];
    }

    try {
      final results = await _searchDataSource.searchWeb(query);
      return results;
    } catch (e) {
      return [];
    }
  }
}
