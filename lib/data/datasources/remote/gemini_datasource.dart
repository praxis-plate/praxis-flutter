import 'package:codium/core/config/env_config.dart';
import 'package:codium/core/exceptions/gemini_exceptions.dart';
import 'package:codium/domain/datasources/i_gemini_datasource.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GeminiDataSource implements IGeminiDataSource {
  GeminiDataSource() : _model = _initializeModel();

  static GenerativeModel _initializeModel() {
    return GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: EnvConfig.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
    );
  }

  final GenerativeModel _model;
  String? _promptTemplate;

  @override
  Future<String> explainText({
    required String text,
    required String context,
  }) async {
    try {
      final prompt = await _buildOptimizedPrompt(text, context);

      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        throw const GeminiEmptyResponseException(
          'Empty response from Gemini API',
        );
      }

      return response.text!;
    } on GenerativeAIException catch (e) {
      final errorMessage = e.message.toLowerCase();

      final talker = GetIt.I<Talker>();
      talker.error('Gemini API error: ${e.message}');

      if (errorMessage.contains('quota') ||
          errorMessage.contains('rate limit') ||
          errorMessage.contains('resource_exhausted')) {
        throw GeminiRateLimitException(
          'Rate limit exceeded. Error: ${e.message}',
        );
      }

      if (errorMessage.contains('api key') ||
          errorMessage.contains('api_key') ||
          errorMessage.contains('invalid')) {
        throw const GeminiInvalidApiKeyException(
          'Invalid API key. Please check your .env configuration.',
        );
      }

      if (errorMessage.contains('not found') ||
          errorMessage.contains('not supported')) {
        throw GeminiModelNotAvailableException(
          'Model not available. Original error: ${e.message}',
        );
      }

      throw GeminiException('AI explanation failed: ${e.message}');
    } on GeminiException {
      rethrow;
    } catch (e) {
      throw GeminiException('Unexpected error: $e');
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
