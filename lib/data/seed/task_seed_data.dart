import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class TaskSeedData {
  static List<TaskCompanion> getTasksForLesson(
    int lessonId,
    String lessonTitle,
    String moduleTitle,
  ) {
    if (moduleTitle == 'Variables and Data Types') {
      return _variablesTasks(lessonId, lessonTitle);
    } else if (moduleTitle == 'Functions') {
      return _functionsTasks(lessonId, lessonTitle);
    } else if (moduleTitle == 'Loops and Iteration') {
      return _loopsTasks(lessonId, lessonTitle);
    }
    return _createGenericTasks(lessonId, lessonTitle);
  }

  static List<TaskCompanion> _variablesTasks(int lessonId, String lessonTitle) {
    if (lessonTitle == 'Introduction to Variables') {
      return _introToVariablesTasks(lessonId);
    } else if (lessonTitle == 'Primitive Data Types') {
      return _primitiveDataTypesTasks(lessonId);
    } else if (lessonTitle == 'Type Conversion') {
      return _typeConversionTasks(lessonId);
    }
    return _createGenericTasks(lessonId, lessonTitle);
  }

  static List<TaskCompanion> _functionsTasks(int lessonId, String lessonTitle) {
    if (lessonTitle == 'Function Basics') {
      return _functionBasicsTasks(lessonId);
    } else if (lessonTitle == 'Parameters and Arguments') {
      return _parametersTasks(lessonId);
    }
    return _createGenericTasks(lessonId, lessonTitle);
  }

  static List<TaskCompanion> _loopsTasks(int lessonId, String lessonTitle) {
    if (lessonTitle == 'For Loops') {
      return _forLoopsTasks(lessonId);
    } else if (lessonTitle == 'While Loops') {
      return _whileLoopsTasks(lessonId);
    }
    return _createGenericTasks(lessonId, lessonTitle);
  }

  static List<TaskCompanion> _introToVariablesTasks(int lessonId) {
    return [
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'What is a variable in programming?',
        correctAnswer: 'A container for storing data values',
        optionsJson: Value(
          jsonEncode([
            'A container for storing data values',
            'A type of loop',
            'A function that returns nothing',
            'A constant value that never changes',
          ]),
        ),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 1,
        xpValue: 10,
        orderIndex: 0,
        fallbackHint: const Value('Think about what variables do in a program'),
        fallbackExplanation: const Value(
          'Variables are containers that store data values which can change during program execution.',
        ),
        topic: 'variables',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'Which keyword is used to declare a variable in Dart?',
        correctAnswer: 'var',
        optionsJson: Value(jsonEncode(['var', 'let', 'variable', 'declare'])),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 1,
        xpValue: 10,
        orderIndex: 1,
        fallbackHint: const Value('Look at the Dart syntax examples'),
        fallbackExplanation: const Value(
          'In Dart, you can use var, int, String, or other type names to declare variables.',
        ),
        topic: 'variables',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'code_completion',
        questionText:
            'Complete the code to declare a variable named age with value 25',
        correctAnswer: 'var age = 25;',
        optionsJson: const Value(null),
        codeTemplate: const Value('var age = ___;'),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 2,
        fallbackHint: const Value('Use an integer value'),
        fallbackExplanation: const Value(
          'To declare a variable, use var followed by the name and assign a value with =',
        ),
        topic: 'variables',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'matching',
        questionText: 'Match the variable declaration with its description',
        correctAnswer: jsonEncode({
          'var name = "Alice"': 'String variable',
          'int count = 10': 'Integer variable',
          'bool isActive = true': 'Boolean variable',
        }),
        optionsJson: const Value(null),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 3,
        fallbackHint: const Value('Look at the data types'),
        fallbackExplanation: const Value(
          'Each variable type stores different kinds of data: String for text, int for numbers, bool for true/false.',
        ),
        topic: 'variables',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText:
            'What happens when you declare a variable without initializing it?',
        correctAnswer: 'It has a null value by default',
        optionsJson: Value(
          jsonEncode([
            'It has a null value by default',
            'It causes a compile error',
            'It automatically gets value 0',
            'It gets deleted immediately',
          ]),
        ),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 3,
        xpValue: 20,
        orderIndex: 4,
        fallbackHint: const Value('Think about uninitialized variables'),
        fallbackExplanation: const Value(
          'In Dart, uninitialized variables have null value by default unless they are non-nullable.',
        ),
        topic: 'variables',
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<TaskCompanion> _primitiveDataTypesTasks(int lessonId) {
    return [
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'Which data type is used for whole numbers?',
        correctAnswer: 'int',
        optionsJson: Value(jsonEncode(['int', 'double', 'String', 'bool'])),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 1,
        xpValue: 10,
        orderIndex: 0,
        fallbackHint: const Value('Think about integer numbers'),
        fallbackExplanation: const Value(
          'int is used for whole numbers without decimals.',
        ),
        topic: 'data_types',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'What data type would you use to store the value 3.14?',
        correctAnswer: 'double',
        optionsJson: Value(jsonEncode(['int', 'double', 'String', 'num'])),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 1,
        fallbackHint: const Value('This is a decimal number'),
        fallbackExplanation: const Value('double is used for decimal numbers.'),
        topic: 'data_types',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'code_completion',
        questionText:
            'Declare a boolean variable named isValid with value true',
        correctAnswer: 'bool isValid = true;',
        optionsJson: const Value(null),
        codeTemplate: const Value('bool isValid = ___;'),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 2,
        fallbackHint: const Value('Use true or false'),
        fallbackExplanation: const Value(
          'Boolean variables can only be true or false.',
        ),
        topic: 'data_types',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'Which data type is used for text?',
        correctAnswer: 'String',
        optionsJson: Value(jsonEncode(['String', 'Text', 'char', 'str'])),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 1,
        xpValue: 10,
        orderIndex: 3,
        fallbackHint: const Value('Think about text data'),
        fallbackExplanation: const Value(
          'String is used for text and characters.',
        ),
        topic: 'data_types',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'matching',
        questionText: 'Match each value with its correct data type',
        correctAnswer: jsonEncode({
          '42': 'int',
          '3.14': 'double',
          'true': 'bool',
          '"Hello"': 'String',
        }),
        optionsJson: const Value(null),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 3,
        xpValue: 20,
        orderIndex: 4,
        fallbackHint: const Value('Look at the format of each value'),
        fallbackExplanation: const Value(
          'Each value has a specific type based on its format and content.',
        ),
        topic: 'data_types',
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<TaskCompanion> _typeConversionTasks(int lessonId) {
    return [
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'How do you convert a String to an int in Dart?',
        correctAnswer: 'int.parse()',
        optionsJson: Value(
          jsonEncode(['int.parse()', 'toInt()', 'parseInt()', 'convert()']),
        ),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 0,
        fallbackHint: const Value('Use the parse method'),
        fallbackExplanation: const Value(
          'int.parse() converts a String to an integer.',
        ),
        topic: 'type_conversion',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'code_completion',
        questionText: 'Convert the string "42" to an integer',
        correctAnswer: 'int num = int.parse("42");',
        optionsJson: const Value(null),
        codeTemplate: const Value('int num = int.parse(___);'),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 1,
        fallbackHint: const Value('Put the string in quotes'),
        fallbackExplanation: const Value(
          'Use int.parse() with the string in quotes.',
        ),
        topic: 'type_conversion',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'What method converts an int to a String?',
        correctAnswer: 'toString()',
        optionsJson: Value(
          jsonEncode(['toString()', 'toStr()', 'String()', 'convert()']),
        ),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 2,
        fallbackHint: const Value('Think about converting to String'),
        fallbackExplanation: const Value(
          'toString() converts any value to a String.',
        ),
        topic: 'type_conversion',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'code_completion',
        questionText: 'Convert the integer 100 to a double',
        correctAnswer: 'double d = 100.toDouble();',
        optionsJson: const Value(null),
        codeTemplate: const Value('double d = 100.___;'),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 3,
        xpValue: 20,
        orderIndex: 3,
        fallbackHint: const Value('Use the toDouble method'),
        fallbackExplanation: const Value(
          'toDouble() converts an int to a double.',
        ),
        topic: 'type_conversion',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText:
            'What happens if you try to parse an invalid string like "abc"?',
        correctAnswer: 'It throws a FormatException',
        optionsJson: Value(
          jsonEncode([
            'It throws a FormatException',
            'It returns 0',
            'It returns null',
            'It returns -1',
          ]),
        ),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 3,
        xpValue: 20,
        orderIndex: 4,
        fallbackHint: const Value('Think about error handling'),
        fallbackExplanation: const Value(
          'Parsing invalid strings throws a FormatException. Use tryParse() for safe parsing.',
        ),
        topic: 'type_conversion',
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<TaskCompanion> _functionBasicsTasks(int lessonId) {
    return [
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText: 'What is the purpose of a function?',
        correctAnswer: 'To group reusable code',
        optionsJson: Value(
          jsonEncode([
            'To group reusable code',
            'To store data',
            'To create variables',
            'To define classes',
          ]),
        ),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 1,
        xpValue: 10,
        orderIndex: 0,
        fallbackHint: const Value('Think about code organization'),
        fallbackExplanation: const Value(
          'Functions group reusable code blocks.',
        ),
        topic: 'functions',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'code_completion',
        questionText: 'Create a function named greet that prints "Hello"',
        correctAnswer: 'void greet() { print("Hello"); }',
        optionsJson: const Value(null),
        codeTemplate: const Value('void greet() { ___ }'),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 1,
        fallbackHint: const Value('Use print statement'),
        fallbackExplanation: const Value(
          'Functions use void when they don\'t return a value.',
        ),
        topic: 'functions',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'multiple_choice',
        questionText:
            'What keyword is used for a function that returns nothing?',
        correctAnswer: 'void',
        optionsJson: Value(jsonEncode(['void', 'null', 'empty', 'none'])),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 2,
        fallbackHint: const Value('Think about return types'),
        fallbackExplanation: const Value('void indicates no return value.'),
        topic: 'functions',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'code_completion',
        questionText: 'Create a function that returns the sum of two numbers',
        correctAnswer: 'int add(int a, int b) { return a + b; }',
        optionsJson: const Value(null),
        codeTemplate: const Value('int add(int a, int b) { return ___; }'),
        testCasesJson: const Value(null),
        programmingLanguage: const Value('dart'),
        difficultyLevel: 3,
        xpValue: 20,
        orderIndex: 3,
        fallbackHint: const Value('Add the parameters'),
        fallbackExplanation: const Value('Return the sum using a + b.'),
        topic: 'functions',
        createdAt: DateTime.now(),
      ),
      TaskCompanion.insert(
        lessonId: lessonId,
        taskType: 'matching',
        questionText: 'Match function parts with their descriptions',
        correctAnswer: jsonEncode({
          'Function name': 'Identifies the function',
          'Parameters': 'Input values',
          'Return type': 'Type of output',
          'Function body': 'Code to execute',
        }),
        optionsJson: const Value(null),
        codeTemplate: const Value(null),
        testCasesJson: const Value(null),
        programmingLanguage: const Value(null),
        difficultyLevel: 2,
        xpValue: 15,
        orderIndex: 4,
        fallbackHint: const Value('Think about function structure'),
        fallbackExplanation: const Value(
          'Each part has a specific role in the function.',
        ),
        topic: 'functions',
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<TaskCompanion> _parametersTasks(int lessonId) {
    return _createGenericTasks(lessonId, 'Parameters');
  }

  static List<TaskCompanion> _forLoopsTasks(int lessonId) {
    return _createGenericTasks(lessonId, 'For Loops');
  }

  static List<TaskCompanion> _whileLoopsTasks(int lessonId) {
    return _createGenericTasks(lessonId, 'While Loops');
  }

  static List<TaskCompanion> _createGenericTasks(int lessonId, String topic) {
    final tasks = <TaskCompanion>[];
    final topicLower = topic.toLowerCase().replaceAll(' ', '_');

    for (int i = 0; i < 7; i++) {
      final difficulty = (i ~/ 2) + 1;
      final xp = difficulty * 10;
      final taskType = _getTaskType(i);

      tasks.add(
        TaskCompanion.insert(
          lessonId: lessonId,
          taskType: taskType,
          questionText: 'Question ${i + 1} about $topic',
          correctAnswer: _getCorrectAnswer(taskType, i),
          optionsJson: taskType == 'multiple_choice'
              ? Value(
                  jsonEncode([
                    _getCorrectAnswer(taskType, i),
                    'Option B',
                    'Option C',
                    'Option D',
                  ]),
                )
              : const Value(null),
          codeTemplate: taskType == 'code_completion'
              ? const Value('// Complete this code\nvar result = ___;')
              : const Value(null),
          testCasesJson: const Value(null),
          programmingLanguage: const Value('dart'),
          difficultyLevel: difficulty.clamp(1, 5),
          xpValue: xp,
          orderIndex: i,
          fallbackHint: Value('Think about $topic concepts'),
          fallbackExplanation: Value(
            'This tests your understanding of $topic.',
          ),
          topic: topicLower,
          createdAt: DateTime.now(),
        ),
      );
    }

    return tasks;
  }

  static String _getTaskType(int index) {
    final types = [
      'multiple_choice',
      'code_completion',
      'matching',
      'text_input',
    ];
    return types[index % types.length];
  }

  static String _getCorrectAnswer(String taskType, int index) {
    if (taskType == 'multiple_choice') {
      return 'Correct answer ${index + 1}';
    } else if (taskType == 'code_completion') {
      return 'result';
    } else if (taskType == 'matching') {
      return jsonEncode({'Term A': 'Definition A', 'Term B': 'Definition B'});
    } else {
      return 'Answer ${index + 1}';
    }
  }
}
