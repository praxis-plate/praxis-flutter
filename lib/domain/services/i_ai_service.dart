import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/enums/programming_language.dart';

abstract interface class IAiService {
  Future<Result<String>> generateHint({
    required String question,
    required String codeContext,
    required ProgrammingLanguage language,
    required String topic,
  });

  Future<Result<String>> generateExplanation({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required ProgrammingLanguage? language,
    required String topic,
    String? compilationError,
  });
}
