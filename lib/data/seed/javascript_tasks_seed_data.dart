import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class JavaScriptTasksSeedData {
  static List<TaskCompanion> getJavaScriptSpecificTasks(
    int lessonId,
    String topic,
  ) {
    return [
      _promisesTask(lessonId, topic, 0),
      _asyncAwaitTask(lessonId, topic, 1),
      _closuresTask(lessonId, topic, 2),
      _arrowFunctionsTask(lessonId, topic, 3),
      _destructuringTask(lessonId, topic, 4),
    ];
  }

  static TaskCompanion _promisesTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'multiple_choice',
      questionText: 'What is a Promise in JavaScript?',
      correctAnswer:
          'An object representing eventual completion of an async operation',
      optionsJson: Value(
        jsonEncode([
          'An object representing eventual completion of an async operation',
          'A type of loop',
          'A variable declaration',
          'A function parameter',
        ]),
      ),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('javascript'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Think about asynchronous operations'),
      fallbackExplanation: const Value(
        'Promises represent the eventual result of an asynchronous operation.',
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
      correctAnswer: 'async function fetchData() { return await fetch(url); }',
      optionsJson: const Value(null),
      codeTemplate: const Value(
        'async function fetchData() { return ___ fetch(url); }',
      ),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('javascript'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Use the await keyword'),
      fallbackExplanation: const Value(
        'async/await makes asynchronous code look and behave like synchronous code.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _closuresTask(int lessonId, String topic, int index) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'multiple_choice',
      questionText: 'What is a closure in JavaScript?',
      correctAnswer: 'A function that has access to its outer scope',
      optionsJson: Value(
        jsonEncode([
          'A function that has access to its outer scope',
          'A way to close a program',
          'A type of loop',
          'A class method',
        ]),
      ),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('javascript'),
      difficultyLevel: 4,
      xpValue: 25,
      orderIndex: index,
      fallbackHint: const Value('Think about function scope'),
      fallbackExplanation: const Value(
        'Closures allow functions to access variables from their outer scope.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _arrowFunctionsTask(
    int lessonId,
    String topic,
    int index,
  ) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'code_completion',
      questionText:
          'Convert this function to arrow function syntax: function double(x) { return x * 2; }',
      correctAnswer: 'const double = (x) => x * 2;',
      optionsJson: const Value(null),
      codeTemplate: const Value('const double = (x) => ___;'),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('javascript'),
      difficultyLevel: 2,
      xpValue: 15,
      orderIndex: index,
      fallbackHint: const Value('Multiply x by 2'),
      fallbackExplanation: const Value(
        'Arrow functions provide a shorter syntax for writing functions.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }

  static TaskCompanion _destructuringTask(
    int lessonId,
    String topic,
    int index,
  ) {
    return TaskCompanion.insert(
      lessonId: lessonId,
      taskType: 'matching',
      questionText:
          'Match JavaScript destructuring patterns with their results',
      correctAnswer: jsonEncode({
        'const {name} = obj': 'Extract name property',
        'const [first] = arr': 'Extract first element',
        'const {x, y} = point': 'Extract multiple properties',
        'const [...rest] = arr': 'Extract remaining elements',
      }),
      optionsJson: const Value(null),
      codeTemplate: const Value(null),
      testCasesJson: const Value(null),
      programmingLanguage: const Value('javascript'),
      difficultyLevel: 3,
      xpValue: 20,
      orderIndex: index,
      fallbackHint: const Value('Think about extracting values'),
      fallbackExplanation: const Value(
        'Destructuring allows unpacking values from arrays or properties from objects.',
      ),
      topic: topic,
      createdAt: DateTime.now(),
    );
  }
}
