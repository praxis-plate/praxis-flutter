import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/enums/programming_language.dart';
import 'package:codium/domain/enums/task_type.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/domain/models/task/test_case_model.dart';

extension TaskEntityExtension on TaskEntity {
  TaskModel toDomain() {
    switch (taskType) {
      case TaskType.multipleChoice:
        return _createMultipleChoiceTask();
      case TaskType.codeCompletion:
        return _createCodeCompletionTask();
      case TaskType.matching:
        return _createMatchingTask();
      case TaskType.textInput:
        return _createTextInputTask();
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
    final parsedTestCases = _decodeTestCasesFromJson(testCasesJson, id);

    return CodeCompletionTaskModel(
      id: id,
      lessonId: lessonId,
      questionText: questionText,
      correctAnswer: correctAnswer,
      codeTemplate: codeTemplate ?? '',
      testCases: parsedTestCases,
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
}

List<TestCaseModel> _decodeTestCasesFromJson(String? json, int taskId) {
  final trimmed = json?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return const [];
  }

  try {
    final decoded = jsonDecode(trimmed);
    final rawList = _extractTestCaseList(decoded);
    if (rawList.isEmpty) {
      return const [];
    }

    final parsed = <TestCaseModel>[];
    for (var i = 0; i < rawList.length; i++) {
      final raw = rawList[i];
      if (raw is! Map) {
        continue;
      }

      final normalized = <String, dynamic>{};
      raw.forEach((key, value) {
        normalized[key.toString()] = value;
      });

      final id = _toInt(normalized['id']) ?? (i + 1);
      final parsedTaskId =
          _toInt(normalized['taskId'] ?? normalized['task_id']) ?? taskId;
      final orderIndex =
          _toInt(normalized['orderIndex'] ?? normalized['order_index']) ?? i;

      parsed.add(
        TestCaseModel(
          id: id,
          taskId: parsedTaskId,
          input: _toString(normalized['input']),
          expectedOutput: _toString(
            normalized['expectedOutput'] ??
                normalized['expected_output'] ??
                normalized['output'],
          ),
          isHidden: _toBool(normalized['isHidden'] ?? normalized['is_hidden']),
          orderIndex: orderIndex,
        ),
      );
    }

    return parsed;
  } catch (_) {
    return const [];
  }
}

List<dynamic> _extractTestCaseList(dynamic decoded) {
  if (decoded is List) {
    return decoded;
  }

  if (decoded is Map) {
    final candidate =
        decoded['testCases'] ?? decoded['test_cases'] ?? decoded['cases'];
    if (candidate is List) {
      return candidate;
    }

    if (candidate is Map) {
      return [candidate];
    }
  }

  return const [];
}

int? _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

bool _toBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true') return true;
    if (normalized == 'false') return false;
    final numberValue = int.tryParse(normalized);
    if (numberValue != null) {
      return numberValue != 0;
    }
  }
  return false;
}

String _toString(dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is String) {
    return value;
  }
  return value.toString();
}
