import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class CourseSeedData {
  static List<CourseCompanion> getCourses() {
    return [
      _programmingFundamentals(),
      _dataStructures(),
      _algorithms(),
      _softwareEngineering(),
    ];
  }

  static CourseCompanion _programmingFundamentals() {
    return CourseCompanion.insert(
      title: 'Programming Fundamentals',
      description:
          'Master the core concepts of programming including variables, functions, loops, conditionals, and object-oriented programming. Perfect for beginners starting their coding journey.',
      author: 'Codium Team',
      category: 'Fundamentals',
      priceInCoins: 0,
      durationMinutes: 480,
      rating: const Value(4.8),
      thumbnailUrl: const Value(null),
      createdAt: DateTime.now(),
    );
  }

  static CourseCompanion _dataStructures() {
    return CourseCompanion.insert(
      title: 'Data Structures',
      description:
          'Learn essential data structures including arrays, lists, trees, graphs, and hash tables. Understand when and how to use each structure effectively.',
      author: 'Codium Team',
      category: 'Computer Science',
      priceInCoins: 100,
      durationMinutes: 600,
      rating: const Value(4.7),
      thumbnailUrl: const Value(null),
      createdAt: DateTime.now(),
    );
  }

  static CourseCompanion _algorithms() {
    return CourseCompanion.insert(
      title: 'Algorithms',
      description:
          'Explore fundamental algorithms including sorting, searching, recursion, and dynamic programming. Build problem-solving skills for technical interviews.',
      author: 'Codium Team',
      category: 'Computer Science',
      priceInCoins: 150,
      durationMinutes: 720,
      rating: const Value(4.9),
      thumbnailUrl: const Value(null),
      createdAt: DateTime.now(),
    );
  }

  static CourseCompanion _softwareEngineering() {
    return CourseCompanion.insert(
      title: 'Software Engineering',
      description:
          'Learn professional software development practices including design patterns, SOLID principles, testing strategies, and refactoring techniques.',
      author: 'Codium Team',
      category: 'Software Engineering',
      priceInCoins: 200,
      durationMinutes: 540,
      rating: const Value(4.6),
      thumbnailUrl: const Value(null),
      createdAt: DateTime.now(),
    );
  }
}
