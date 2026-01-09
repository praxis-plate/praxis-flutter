import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/enums/programming_language.dart';
import 'package:codium/domain/models/task/task_models.dart';

extension TaskEntityExtension on TaskEntity {
  TaskModel toDomain() {
    final taskTypeString = _snakeToCamelCase(taskType);

    switch (taskTypeString) {
      case 'multipleChoice':
        return _createMultipleChoiceTask();
      case 'codeCompletion':
        return _createCodeCompletionTask();
      case 'matching':
        return _createMatchingTask();
      case 'textInput':
        return _createTextInputTask();
      default:
        return _createMultipleChoiceTask(); // fallback
    }
  }

  MultipleChoiceTaskModel _createMultipleChoiceTask() {
    return MultipleChoiceTaskModel(
      id: id,
      lessonId: lessonId,
      questionText: questionText,
      correctAnswer: correctAnswer,
      options: optionsJson != null
          ? (jsonDecode(optionsJson!) as List<dynamic>)
                .map((e) => e.toString())
                .toList()
          : [],
      difficultyLevel: difficultyLevel,
      xpValue: xpValue,
      orderIndex: orderIndex,
      fallbackHint: fallbackHint,
      fallbackExplanation: fallbackExplanation,
      topic: topic,
      createdAt: createdAt,
    );
  }

  CodeCompletionTaskModel _createCodeCompletionTask() {
    return CodeCompletionTaskModel(
      id: id,
      lessonId: lessonId,
      questionText: questionText,
      correctAnswer: correctAnswer,
      codeTemplate: codeTemplate ?? '',
      testCases: const [], // TODO: Implement test cases parsing
      language: programmingLanguage != null
          ? ProgrammingLanguage.values.firstWhere(
              (e) => e.name == programmingLanguage,
              orElse: () => ProgrammingLanguage.dart,
            )
          : ProgrammingLanguage.dart,
      difficultyLevel: difficultyLevel,
      xpValue: xpValue,
      orderIndex: orderIndex,
      fallbackHint: fallbackHint,
      fallbackExplanation: fallbackExplanation,
      topic: topic,
      createdAt: createdAt,
    );
  }

  MatchingTaskModel _createMatchingTask() {
    // Парсим пары из JSON или другого формата
    final pairs = <MatchingPair>[];
    final leftItems = <String>[];
    final rightItems = <String>[];

    if (optionsJson != null) {
      try {
        final data = jsonDecode(optionsJson!) as Map<String, dynamic>;
        final pairsData = data['pairs'] as List<dynamic>? ?? [];

        for (final pairData in pairsData) {
          final pair = pairData as Map<String, dynamic>;
          final left = pair['left'] as String;
          final right = pair['right'] as String;

          pairs.add(MatchingPair(left: left, right: right));
          if (!leftItems.contains(left)) leftItems.add(left);
          if (!rightItems.contains(right)) rightItems.add(right);
        }
      } catch (e) {
        // Fallback если не удалось распарсить
      }
    }

    return MatchingTaskModel(
      id: id,
      lessonId: lessonId,
      questionText: questionText,
      correctAnswer: correctAnswer,
      pairs: pairs,
      leftItems: leftItems,
      rightItems: rightItems,
      difficultyLevel: difficultyLevel,
      xpValue: xpValue,
      orderIndex: orderIndex,
      fallbackHint: fallbackHint,
      fallbackExplanation: fallbackExplanation,
      topic: topic,
      createdAt: createdAt,
    );
  }

  TextInputTaskModel _createTextInputTask() {
    bool caseSensitive = false;
    bool exactMatch = false;
    List<String>? acceptableAnswers;

    if (optionsJson != null) {
      try {
        final data = jsonDecode(optionsJson!) as Map<String, dynamic>;
        caseSensitive = data['caseSensitive'] as bool? ?? false;
        exactMatch = data['exactMatch'] as bool? ?? false;
        acceptableAnswers = (data['acceptableAnswers'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList();
      } catch (e) {
        // Fallback если не удалось распарсить
      }
    }

    return TextInputTaskModel(
      id: id,
      lessonId: lessonId,
      questionText: questionText,
      correctAnswer: correctAnswer,
      caseSensitive: caseSensitive,
      exactMatch: exactMatch,
      acceptableAnswers: acceptableAnswers,
      difficultyLevel: difficultyLevel,
      xpValue: xpValue,
      orderIndex: orderIndex,
      fallbackHint: fallbackHint,
      fallbackExplanation: fallbackExplanation,
      topic: topic,
      createdAt: createdAt,
    );
  }

  String _snakeToCamelCase(String snakeCase) {
    final parts = snakeCase.split('_');
    if (parts.length == 1) return snakeCase;

    return parts.first +
        parts.skip(1).map((part) {
          if (part.isEmpty) return '';
          return part[0].toUpperCase() + part.substring(1);
        }).join();
  }
}
