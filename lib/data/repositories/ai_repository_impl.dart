import 'package:codium/core/exceptions/app_exception.dart';
import 'package:codium/data/datasources/remote/gemini_datasource.dart';
import 'package:codium/data/datasources/remote/search_datasource.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/domain/repositories/ai_repository.dart';
import 'package:codium/domain/services/connectivity_service.dart';
import 'package:dio/dio.dart';

class AiRepositoryImpl implements IAiRepository {
  AiRepositoryImpl({
    required GeminiDataSource geminiDataSource,
    required SearchDataSource searchDataSource,
    required IConnectivityService connectivityService,
  }) : _geminiDataSource = geminiDataSource,
       _searchDataSource = searchDataSource,
       _connectivityService = connectivityService;

  final GeminiDataSource _geminiDataSource;
  final SearchDataSource _searchDataSource;
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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkError.noInternet(
          message:
              'No internet connection. AI features require internet access.',
        );
      }

      if (e.message?.contains('Rate limit') ?? false) {
        throw const RateLimitError(
          message:
              'AI service is temporarily unavailable due to rate limits. Please try again in a few moments.',
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
