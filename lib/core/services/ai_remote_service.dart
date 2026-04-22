import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/enums/programming_language.dart';
import 'package:praxis/domain/services/i_ai_service.dart';
import 'package:praxis_client/praxis_client.dart';

class AiRemoteService implements IAiService {
  final Client _client;

  const AiRemoteService(this._client);

  @override
  Future<Result<String>> generateHint({
    required String question,
    required String codeContext,
    required ProgrammingLanguage language,
    required String topic,
  }) async {
    try {
      final request = GenerateHintRequest(
        question: question,
        codeContext: codeContext,
        language: language.displayName,
        topic: topic,
      );

      final response = await _client.ai.generateHint(request);
      return Success(response.content);
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
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
    try {
      final request = GenerateExplanationRequest(
        question: question,
        userAnswer: userAnswer,
        correctAnswer: correctAnswer,
        language: language?.displayName ?? 'programming',
        topic: topic,
        compilationError: compilationError,
      );

      final response = await _client.ai.generateExplanation(request);
      return Success(response.content);
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }
}
