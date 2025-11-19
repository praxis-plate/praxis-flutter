import 'package:codium/core/config/env_config.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiDataSource {
  GeminiDataSource() : _model = _initializeModel();

  static GenerativeModel _initializeModel() {
    return GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: EnvConfig.geminiApiKey,
    );
  }

  final GenerativeModel _model;
  String? _promptTemplate;

  Future<String> explainText({
    required String text,
    required String context,
  }) async {
    try {
      final prompt = await _buildOptimizedPrompt(text, context);

      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        throw dio.DioException(
          requestOptions: dio.RequestOptions(path: ''),
          type: dio.DioExceptionType.badResponse,
          message: 'Empty response from Gemini API',
        );
      }

      return response.text!;
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('rate limit')) {
        throw dio.DioException(
          requestOptions: dio.RequestOptions(path: ''),
          type: dio.DioExceptionType.unknown,
          message: 'Rate limit exceeded. Please try again later.',
        );
      }
      throw dio.DioException(
        requestOptions: dio.RequestOptions(path: ''),
        type: dio.DioExceptionType.unknown,
        message: 'AI explanation failed: ${e.message}',
      );
    } catch (e) {
      throw dio.DioException(
        requestOptions: dio.RequestOptions(path: ''),
        type: dio.DioExceptionType.unknown,
        message: 'Unexpected error: $e',
      );
    }
  }

  Future<String> _buildOptimizedPrompt(String text, String context) async {
    _promptTemplate ??= await rootBundle.loadString(
      'assets/prompts/ai_tutor_prompt.txt',
    );

    return _promptTemplate!
        .replaceAll('{text}', text)
        .replaceAll('{context}', context);
  }
}
