import 'package:codium/core/config/env_config.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/core/utils/template_renderer.dart';
import 'package:codium/domain/enums/programming_language.dart';
import 'package:codium/domain/services/i_ai_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AiService implements IAiService {
  final Dio _dio;
  final String _apiKey;
  final String _model;

  String _hintPromptTemplate = '';
  String _explanationPromptTemplate = '';

  AiService({
    required Dio dio,
    String? apiKey,
    String model = 'gemini-2.5-flash',
  }) : _dio = dio,
       _apiKey = apiKey ?? EnvConfig.geminiApiKey,
       _model = model {
    _loadPromptTemplates();
  }

  Future<void> _loadPromptTemplates() async {
    try {
      _hintPromptTemplate = await rootBundle.loadString(
        'assets/prompts/task_hint_prompt.txt',
      );
      _explanationPromptTemplate = await rootBundle.loadString(
        'assets/prompts/task_explanation_prompt.txt',
      );
    } catch (e, stackTrace) {
      GetIt.I<Talker>().error('Failed to load prompt templates', e, stackTrace);
    }
  }

  @override
  Future<Result<String>> generateHint({
    required String question,
    required String codeContext,
    required ProgrammingLanguage language,
    required String topic,
  }) async {
    final prompt = _buildHintPrompt(
      question: question,
      codeContext: codeContext,
      language: language,
      topic: topic,
    );

    return await _makeRequest(prompt);
  }

  @override
  Future<Result<String>> generateExplanation({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required ProgrammingLanguage? language,
    required String topic,
    String? compilationError,
  }) async {
    final prompt = _buildExplanationPrompt(
      question: question,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
      language: language,
      topic: topic,
      compilationError: compilationError,
    );

    return await _makeRequest(prompt);
  }

  String _buildHintPrompt({
    required String question,
    required String codeContext,
    required ProgrammingLanguage language,
    required String topic,
  }) {
    final languageName = language.displayName;
    final codeContextSection = codeContext.isEmpty
        ? ''
        : 'Code context:\n```$languageName\n$codeContext\n```\n';

    return TemplateRenderer.render(_hintPromptTemplate, {
      'language': languageName,
      'topic': topic,
      'question': question,
      'code_context': codeContextSection,
    });
  }

  String _buildExplanationPrompt({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required ProgrammingLanguage? language,
    required String topic,
    String? compilationError,
  }) {
    final languageName = language?.displayName ?? 'programming';
    final compilationErrorSection =
        compilationError == null || compilationError.isEmpty
        ? ''
        : 'Compilation error:\n$compilationError\n';

    return TemplateRenderer.render(_explanationPromptTemplate, {
      'language': languageName,
      'topic': topic,
      'question': question,
      'user_answer': userAnswer,
      'correct_answer': correctAnswer,
      'compilation_error': compilationErrorSection,
    });
  }

  Future<Result<String>> _makeRequest(String prompt) async {
    try {
      final url =
          'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      };

      GetIt.I<Talker>().debug('=== Gemini API Request ===');
      GetIt.I<Talker>().debug('URL: $url');
      GetIt.I<Talker>().debug('Model: $_model');
      GetIt.I<Talker>().debug(
        'API Key (first 10 chars): ${_apiKey.substring(0, 10)}...',
      );
      GetIt.I<Talker>().debug('Request body: $requestBody');
      GetIt.I<Talker>().debug('Prompt length: ${prompt.length} chars');

      final response = await _dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: {
            'x-goog-api-key': _apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      GetIt.I<Talker>().debug(
        'Gemini API response status: ${response.statusCode}',
      );

      final text = _parseResponse(response.data);
      if (text == null) {
        return const Failure(
          AppFailure.parsing(message: 'Failed to parse AI response'),
        );
      }

      return Success(text);
    } on DioException catch (e) {
      return Failure(AppFailure.fromDioException(e));
    } catch (e, stackTrace) {
      GetIt.I<Talker>().error(
        'Unexpected error in Gemini API request',
        e,
        stackTrace,
      );

      return Failure(AppFailure.fromException(e));
    }
  }

  String? _parseResponse(dynamic data) {
    try {
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

      if (text == null || text is! String) {
        GetIt.I<Talker>().error('Failed to extract text from response: $data');
        return null;
      }

      return text;
    } catch (e, stackTrace) {
      GetIt.I<Talker>().error('Error parsing Gemini response', e, stackTrace);
      return null;
    }
  }
}
