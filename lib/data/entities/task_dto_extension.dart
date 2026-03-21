import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/enums/programming_language.dart';
import 'package:codium/domain/enums/task_type.dart' as domain;
import 'package:codium/domain/models/task/task_model.dart';
import 'package:codium/domain/models/task/test_case_model.dart';
import 'package:drift/drift.dart';
import 'package:praxis_client/praxis_client.dart';

extension TaskDtoExtension on TaskDto {
  TaskModel toDomain() {
    switch (taskType) {
      case TaskType.multipleChoice:
        return MultipleChoiceTaskModel(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          options: options.map((o) => o.optionText).toList(),
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
        );
      case TaskType.codeCompletion:
        return CodeCompletionTaskModel(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          codeTemplate: codeTemplate ?? '',
          language: ProgrammingLanguage.values.firstWhere(
            (lang) => lang.name == programmingLanguage,
            orElse: () => ProgrammingLanguage.dart,
          ),
          testCases: testCases
              .map(
                (tc) => TestCaseModel(
                  id: tc.id,
                  taskId: tc.taskId,
                  input: tc.input,
                  expectedOutput: tc.expectedOutput,
                  isHidden: false,
                  orderIndex: 0,
                ),
              )
              .toList(),
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
        );
      case TaskType.textInput:
        return TextInputTaskModel(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
        );
      case TaskType.matching:
        return MatchingTaskModel.fromMatchingData(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
          matchingDataJson: optionsJson,
        );
    }
  }
}

extension TaskDtoCompanionExtension on TaskDto {
  TaskCompanion toCompanion() {
    return TaskCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      taskType: Value(
        domain.TaskType.values.firstWhere(
          (value) => value.name == taskType.name,
        ),
      ),
      questionText: Value(questionText),
      correctAnswer: Value(correctAnswer),
      optionsJson: Value(_resolveOptionsJson()),
      codeTemplate: Value(codeTemplate),
      testCasesJson: Value(_resolveTestCasesJson()),
      programmingLanguage: Value(programmingLanguage),
      difficultyLevel: Value(difficultyLevel),
      xpValue: Value(xpValue),
      orderIndex: Value(orderIndex),
      fallbackHint: Value(fallbackHint),
      fallbackExplanation: Value(fallbackExplanation),
      topic: Value(topic),
      createdAt: Value(createdAt),
    );
  }

  String? _resolveOptionsJson() {
    if (optionsJson != null) {
      return optionsJson;
    }

    if (taskType == TaskType.multipleChoice) {
      final optionsList = options.map((option) => option.optionText).toList();
      return jsonEncode(optionsList);
    }

    return null;
  }

  String? _resolveTestCasesJson() {
    if (testCasesJson != null) {
      return testCasesJson;
    }

    if (taskType != TaskType.codeCompletion || testCases.isEmpty) {
      return null;
    }

    final serialized = testCases
        .map(
          (testCase) => {
            'id': testCase.id,
            'taskId': testCase.taskId,
            'input': testCase.input,
            'expectedOutput': testCase.expectedOutput,
            'isHidden': testCase.isHidden,
            'orderIndex': testCase.orderIndex,
          },
        )
        .toList();

    return jsonEncode(serialized);
  }
}
