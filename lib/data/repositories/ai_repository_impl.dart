import 'package:codium/data/datasources/remote/gemini_datasource.dart';
import 'package:codium/data/datasources/remote/search_datasource.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/domain/repositories/ai_repository.dart';
import 'package:dio/dio.dart';

class AiRepositoryImpl implements IAiRepository {
  AiRepositoryImpl({
    required GeminiDataSource geminiDataSource,
    required SearchDataSource searchDataSource,
  }) : _geminiDataSource = geminiDataSource,
       _searchDataSource = searchDataSource;

  final GeminiDataSource _geminiDataSource;
  final SearchDataSource _searchDataSource;

  @override
  Future<String> explainText({
    required String text,
    required String context,
  }) async {
    try {
      final explanation = await _geminiDataSource.explainText(
        text: text,
        context: context,
      );

      return explanation;
    } on DioException catch (e) {
      if (e.message?.contains('Rate limit') ?? false) {
        throw Exception(
          'AI service is temporarily unavailable due to rate limits. Please try again in a few moments.',
        );
      }
      throw Exception('Failed to generate explanation: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while generating explanation: $e');
    }
  }

  @override
  Future<List<SearchSource>> searchWeb(String query) async {
    try {
      final results = await _searchDataSource.searchWeb(query);
      return results;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return [];
      }

      if (e.message?.contains('rate limit') ?? false) {
        return [];
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
