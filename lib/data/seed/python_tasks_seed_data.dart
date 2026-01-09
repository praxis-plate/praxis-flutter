import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class PythonTasksSeedData {
  static List<TaskCompanion> getPythonSpecificTasks(
    int lessonId,
    String topic,
  ) {
    return [
      _listComprehensionTask(lessonId, topic, 0),
      _decoratorsTask(lessonId, topic, 1),
      _generatorsTask(lessonId, topic, 2),
      _lambdaTask(lessonId, topic, 3),
      _dictionaryTask(lessonId, topic, 4),
    ];
  }

  static TaskCompanion _listComprehensionTask(
    int lessonId,
    String topic,
    int index,
  ) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'code_completion',
      questionText:
          'Create a list of squares from 0 to 9 using list comprehension',
      correctAnswer: 'squares = [x**2 for x in range(10)]',
      optionsJson: const Value(null),
      codeTemplate: const Value('squares = [___ for x in range(10)]'),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('python'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Use the ** operator for power'),
      fallbackExplanation: const Value(
        'List comprehensions provide a concise way to create lists in Python.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _decoratorsTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'multiple_choice',
      questionText: 'What is a decorator in Python?',
      correctAnswer: 'A function that modifies another function',
      optionsJson: Value(
        jsonEncode([
          'A function that modifies another function',
          'A type of class',
          'A loop structure',
          'A data type',
        ]),
      ),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('python'),
      difficultyLevel: 4,
      xpValue: 25,
      orderIndex: index,
      fallbackHint: const Value('Think about function wrappers'),
      fallbackExplanation: const Value(
        'Decorators allow you to modify or enhance functions without changing their code.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _generatorsTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'multiple_choice',
      questionText: 'What keyword is used to create a generator in Python?',
      correctAnswer: 'yield',
      optionsJson: Value(jsonEncode(['yield', 'return', 'generate', 'next'])),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('python'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Think about lazy evaluation'),
      fallbackExplanation: const Value(
        'yield creates a generator that produces values one at a time.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _lambdaTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'code_completion',
      questionText: 'Create a lambda function that doubles a number',
      correctAnswer: 'double = lambda x: x * 2',
      optionsJson: const Value(null),
      codeTemplate: const Value('double = lambda x: ___'),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('python'),
      difficultyLevel: 2,
      xpValue: 15,
      orderIndex: index,
      fallbackHint: const Value('Multiply by 2'),
      fallbackExplanation: const Value(
        'Lambda functions are anonymous functions defined with the lambda keyword.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _dictionaryTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'matching',
      questionText: 'Match Python dictionary operations with their results',
      correctAnswer: jsonEncode({
        'dict.keys()': 'Returns all keys',
        'dict.values()': 'Returns all values',
        'dict.items()': 'Returns key-value pairs',
        'dict.get(key)': 'Returns value for key',
      }),
      optionsJson: const Value(null),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('python'),
      difficultyLevel: 2,
      xpValue: 15,
      orderIndex: index,
      fallbackHint: const Value('Think about dictionary methods'),
      fallbackExplanation: const Value(
        'Python dictionaries have various methods to access keys, values, and items.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }
}
