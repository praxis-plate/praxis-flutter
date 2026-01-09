import 'package:codium/data/database/app_database.dart';

class ModuleSeedData {
  static List<ModuleCompanion> getModulesForCourse(
    int courseId,
    String courseTitle,
  ) {
    switch (courseTitle) {
      case 'Programming Fundamentals':
        return _programmingFundamentalsModules(courseId);
      case 'Data Structures':
        return _dataStructuresModules(courseId);
      case 'Algorithms':
        return _algorithmsModules(courseId);
      case 'Software Engineering':
        return _softwareEngineeringModules(courseId);
      default:
        return [];
    }
  }

  static List<ModuleCompanion> _programmingFundamentalsModules(int courseId) {
    return [
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Variables and Data Types',
        description:
            'Learn about variables, primitive data types, and how to store and manipulate data in your programs.',
        orderIndex: 0,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Functions',
        description:
            'Master function declaration, parameters, return values, and scope. Learn to write reusable code.',
        orderIndex: 1,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Loops and Iteration',
        description:
            'Understand for loops, while loops, and iteration patterns. Learn to process collections efficiently.',
        orderIndex: 2,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Conditionals',
        description:
            'Learn if-else statements, switch cases, and boolean logic. Control program flow based on conditions.',
        orderIndex: 3,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Object-Oriented Programming',
        description:
            'Explore classes, objects, inheritance, and polymorphism. Build modular and maintainable code.',
        orderIndex: 4,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<ModuleCompanion> _dataStructuresModules(int courseId) {
    return [
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Arrays',
        description:
            'Master array operations, indexing, and common array algorithms. Foundation for all data structures.',
        orderIndex: 0,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Lists',
        description:
            'Learn about dynamic lists, linked lists, and list operations. Understand time complexity trade-offs.',
        orderIndex: 1,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Trees',
        description:
            'Explore binary trees, binary search trees, and tree traversal algorithms. Essential for hierarchical data.',
        orderIndex: 2,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Graphs',
        description:
            'Understand graph representations, traversal algorithms, and common graph problems.',
        orderIndex: 3,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Hash Tables',
        description:
            'Learn hash functions, collision resolution, and hash table applications. Achieve O(1) lookups.',
        orderIndex: 4,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<ModuleCompanion> _algorithmsModules(int courseId) {
    return [
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Sorting Algorithms',
        description:
            'Master bubble sort, merge sort, quick sort, and their time complexities. Choose the right algorithm.',
        orderIndex: 0,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Searching Algorithms',
        description:
            'Learn linear search, binary search, and search optimization techniques.',
        orderIndex: 1,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Recursion',
        description:
            'Understand recursive thinking, base cases, and recursive problem-solving patterns.',
        orderIndex: 2,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Dynamic Programming',
        description:
            'Master memoization, tabulation, and solving optimization problems efficiently.',
        orderIndex: 3,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<ModuleCompanion> _softwareEngineeringModules(int courseId) {
    return [
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Design Patterns',
        description:
            'Learn creational, structural, and behavioral design patterns. Write elegant solutions.',
        orderIndex: 0,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'SOLID Principles',
        description:
            'Master the five principles of object-oriented design for maintainable code.',
        orderIndex: 1,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Testing',
        description:
            'Learn unit testing, integration testing, and test-driven development practices.',
        orderIndex: 2,
        createdAt: DateTime.now(),
      ),
      ModuleCompanion.insert(
        courseId: courseId,
        title: 'Refactoring',
        description:
            'Understand code smells, refactoring techniques, and improving code quality.',
        orderIndex: 3,
        createdAt: DateTime.now(),
      ),
    ];
  }
}
