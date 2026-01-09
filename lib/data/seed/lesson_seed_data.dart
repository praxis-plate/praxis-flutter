import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class LessonSeedData {
  static List<LessonCompanion> getLessonsForModule(
    int moduleId,
    String moduleTitle,
  ) {
    switch (moduleTitle) {
      case 'Variables and Data Types':
        return _variablesLessons(moduleId);
      case 'Functions':
        return _functionsLessons(moduleId);
      case 'Loops and Iteration':
        return _loopsLessons(moduleId);
      case 'Conditionals':
        return _conditionalsLessons(moduleId);
      case 'Object-Oriented Programming':
        return _oopLessons(moduleId);
      case 'Arrays':
        return _arraysLessons(moduleId);
      case 'Lists':
        return _listsLessons(moduleId);
      case 'Trees':
        return _treesLessons(moduleId);
      case 'Graphs':
        return _graphsLessons(moduleId);
      case 'Hash Tables':
        return _hashTablesLessons(moduleId);
      case 'Sorting Algorithms':
        return _sortingLessons(moduleId);
      case 'Searching Algorithms':
        return _searchingLessons(moduleId);
      case 'Recursion':
        return _recursionLessons(moduleId);
      case 'Dynamic Programming':
        return _dynamicProgrammingLessons(moduleId);
      case 'Design Patterns':
        return _designPatternsLessons(moduleId);
      case 'SOLID Principles':
        return _solidLessons(moduleId);
      case 'Testing':
        return _testingLessons(moduleId);
      case 'Refactoring':
        return _refactoringLessons(moduleId);
      default:
        return [];
    }
  }

  static List<LessonCompanion> _variablesLessons(int moduleId) {
    return [
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Introduction to Variables',
        contentText:
            '''Variables are containers for storing data values. In programming, you declare a variable to hold information that can change during program execution.

Key concepts:
- Variable declaration and initialization
- Naming conventions
- Variable scope
- Mutable vs immutable variables

Example in Dart:
```dart
var name = 'Alice';
int age = 25;
final String city = 'New York';
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 0,
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Primitive Data Types',
        contentText:
            '''Primitive data types are the basic building blocks of data in programming. They represent simple values.

Common primitive types:
- int: whole numbers (1, 42, -10)
- double: decimal numbers (3.14, -0.5)
- bool: true or false
- String: text ("Hello", 'World')

Example:
```dart
int count = 10;
double price = 19.99;
bool isActive = true;
String message = 'Hello World';
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 1,
        durationMinutes: 20,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Type Conversion',
        contentText:
            '''Type conversion allows you to change data from one type to another. This is essential when working with different data types.

Types of conversion:
- Implicit conversion (automatic)
- Explicit conversion (manual casting)
- Parsing strings to numbers
- Converting numbers to strings

Example:
```dart
String numStr = '42';
int num = int.parse(numStr);
double decimal = num.toDouble();
String back = decimal.toString();
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 2,
        durationMinutes: 18,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Constants and Final Variables',
        contentText:
            '''Constants are values that cannot be changed after initialization. They help prevent bugs and make code more maintainable.

Key differences:
- const: compile-time constant
- final: runtime constant
- var: mutable variable

Example:
```dart
const double PI = 3.14159;
final DateTime now = DateTime.now();
var counter = 0;
counter++;
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 3,
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Variable Scope',
        contentText:
            '''Variable scope determines where a variable can be accessed in your code. Understanding scope prevents errors and improves code organization.

Scope types:
- Global scope: accessible everywhere
- Local scope: accessible within a block
- Function scope: accessible within a function
- Class scope: accessible within a class

Example:
```dart
var global = 'I am global';

void myFunction() {
  var local = 'I am local';
  print(global);
  print(local);
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 4,
        durationMinutes: 20,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<LessonCompanion> _functionsLessons(int moduleId) {
    return [
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Function Basics',
        contentText:
            '''Functions are reusable blocks of code that perform specific tasks. They help organize code and avoid repetition.

Function components:
- Function name
- Parameters (inputs)
- Return type
- Function body

Example:
```dart
int add(int a, int b) {
  return a + b;
}

var result = add(5, 3);
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 0,
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Parameters and Arguments',
        contentText:
            '''Parameters are variables in function definitions. Arguments are the actual values passed when calling functions.

Parameter types:
- Required parameters
- Optional positional parameters
- Named parameters
- Default parameter values

Example:
```dart
void greet(String name, {String greeting = 'Hello'}) {
  print('\$greeting, \$name!');
}

greet('Alice');
greet('Bob', greeting: 'Hi');
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 1,
        durationMinutes: 20,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Return Values',
        contentText:
            '''Functions can return values to the caller. The return type specifies what kind of value the function produces.

Return concepts:
- Return type declaration
- Return statement
- Void functions (no return)
- Multiple return points

Example:
```dart
bool isEven(int number) {
  return number % 2 == 0;
}

void printMessage(String msg) {
  print(msg);
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 2,
        durationMinutes: 18,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Arrow Functions',
        contentText:
            '''Arrow functions provide a concise syntax for simple functions. They are perfect for one-line expressions.

Syntax:
- Use => for single expression
- Implicit return
- Shorter and cleaner code

Example:
```dart
int square(int x) => x * x;
bool isPositive(int n) => n > 0;
String greet(String name) => 'Hello, \$name!';
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 3,
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Higher-Order Functions',
        contentText:
            '''Higher-order functions take other functions as parameters or return functions. They enable powerful functional programming patterns.

Common patterns:
- map: transform each element
- filter: select elements
- reduce: combine elements
- forEach: iterate with side effects

Example:
```dart
List<int> numbers = [1, 2, 3, 4];
var doubled = numbers.map((n) => n * 2).toList();
var evens = numbers.where((n) => n % 2 == 0).toList();
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 4,
        durationMinutes: 25,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<LessonCompanion> _loopsLessons(int moduleId) {
    return [
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'For Loops',
        contentText:
            '''For loops repeat code a specific number of times. They are perfect when you know how many iterations you need.

Example:
```dart
for (int i = 0; i < 5; i++) {
  print('Count: \$i');
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 0,
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'While Loops',
        contentText:
            '''While loops continue as long as a condition is true. Use them when the number of iterations is unknown.

Example:
```dart
int count = 0;
while (count < 5) {
  print(count);
  count++;
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 1,
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'For-In Loops',
        contentText:
            '''For-in loops iterate over collections. They provide clean syntax for processing each element.

Example:
```dart
List<String> fruits = ['apple', 'banana', 'orange'];
for (var fruit in fruits) {
  print(fruit);
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 2,
        durationMinutes: 12,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Break and Continue',
        contentText:
            '''Break exits a loop early. Continue skips to the next iteration.

Example:
```dart
for (int i = 0; i < 10; i++) {
  if (i == 5) break;
  if (i % 2 == 0) continue;
  print(i);
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 3,
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      LessonCompanion.insert(
        moduleId: moduleId,
        title: 'Nested Loops',
        contentText:
            '''Nested loops are loops inside loops. Useful for multi-dimensional data.

Example:
```dart
for (int i = 0; i < 3; i++) {
  for (int j = 0; j < 3; j++) {
    print('\$i, \$j');
  }
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: 4,
        durationMinutes: 20,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<LessonCompanion> _conditionalsLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Conditionals', 5);
  }

  static List<LessonCompanion> _oopLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'OOP', 7);
  }

  static List<LessonCompanion> _arraysLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Arrays', 6);
  }

  static List<LessonCompanion> _listsLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Lists', 6);
  }

  static List<LessonCompanion> _treesLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Trees', 7);
  }

  static List<LessonCompanion> _graphsLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Graphs', 6);
  }

  static List<LessonCompanion> _hashTablesLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Hash Tables', 5);
  }

  static List<LessonCompanion> _sortingLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Sorting', 6);
  }

  static List<LessonCompanion> _searchingLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Searching', 5);
  }

  static List<LessonCompanion> _recursionLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Recursion', 6);
  }

  static List<LessonCompanion> _dynamicProgrammingLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Dynamic Programming', 7);
  }

  static List<LessonCompanion> _designPatternsLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Design Patterns', 8);
  }

  static List<LessonCompanion> _solidLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'SOLID', 5);
  }

  static List<LessonCompanion> _testingLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Testing', 6);
  }

  static List<LessonCompanion> _refactoringLessons(int moduleId) {
    return _createGenericLessons(moduleId, 'Refactoring', 6);
  }

  static List<LessonCompanion> _createGenericLessons(
    int moduleId,
    String topic,
    int count,
  ) {
    return List.generate(
      count,
      (index) => LessonCompanion.insert(
        moduleId: moduleId,
        title: '$topic Lesson ${index + 1}',
        contentText:
            '''This is lesson ${index + 1} about $topic.

Learn key concepts and practice with interactive tasks.

Example code:
```dart
void example() {
  print('$topic example');
}
```''',
        videoUrl: const Value(null),
        imageUrls: const Value(null),
        orderIndex: index,
        durationMinutes: 15 + (index * 2),
        createdAt: DateTime.now(),
      ),
    );
  }
}
