import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class DartTasksSeedData {
  static List<TaskCompanion> getDartSpecificTasks(int lessonId, String topic) {
    return [
      _nullSafetyTask(lessonId, topic, 0),
      _asyncAwaitTask(lessonId, topic, 1),
      _streamsTask(lessonId, topic, 2),
      _extensionsTask(lessonId, topic, 3),
      _cascadeOperatorTask(lessonId, topic, 4),
    ];
  }

  static TaskCompanion _nullSafetyTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'multiple_choice',
      questionText: 'What does the ? operator mean in Dart null safety?',
      correctAnswer: 'The variable can be null',
      optionsJson: Value(
        jsonEncode([
          'The variable can be null',
          'The variable is required',
          'The variable is constant',
          'The variable is private',
        ]),
      ),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('dart'),
      difficultyLevel: 2,
      xpValue: 15,
      orderIndex: index,
      fallbackHint: const Value('Think about nullable types'),
      fallbackExplanation: const Value(
        'The ? operator makes a type nullable, meaning it can hold null values.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _asyncAwaitTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'code_completion',
      questionText: 'Complete the async function to fetch data',
      correctAnswer:
          'Future<String> fetchData() async { return await getData(); }',
      optionsJson: const Value(null),
      codeTemplate: const Value(
        'Future<String> fetchData() async { return ___ getData(); }',
      ),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('dart'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Use the await keyword'),
      fallbackExplanation: const Value(
        'async/await allows you to write asynchronous code that looks synchronous.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _streamsTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'multiple_choice',
      questionText: 'What is a Stream in Dart?',
      correctAnswer: 'A sequence of asynchronous events',
      optionsJson: Value(
        jsonEncode([
          'A sequence of asynchronous events',
          'A type of list',
          'A database connection',
          'A file reader',
        ]),
      ),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('dart'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Think about async data flow'),
      fallbackExplanation: const Value(
        'Streams provide a way to receive a sequence of events over time.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _extensionsTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'code_completion',
      questionText: 'Create an extension method to check if a string is empty',
      correctAnswer:
          'extension StringExt on String { bool get isEmpty => length == 0; }',
      optionsJson: const Value(null),
      codeTemplate: const Value(
        'extension StringExt on String { bool get isEmpty => ___; }',
      ),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('dart'),
      difficultyLevel: 4,
      xpValue: 25,
      orderIndex: index,
      fallbackHint: const Value('Check the length property'),
      fallbackExplanation: const Value(
        'Extensions add functionality to existing types without modifying them.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _cascadeOperatorTask(
    int lessonId,
    String topic,
    int index,
  ) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'multiple_choice',
      questionText: 'What does the cascade operator (..) do in Dart?',
      correctAnswer: 'Allows multiple operations on the same object',
      optionsJson: Value(
        jsonEncode([
          'Allows multiple operations on the same object',
          'Creates a copy of an object',
          'Compares two objects',
          'Deletes an object',
        ]),
      ),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('dart'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Think about chaining operations'),
      fallbackExplanation: const Value(
        'The cascade operator allows you to perform multiple operations on the same object.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }
}
