import 'package:codium/domain/enums/task_type.dart';
import 'package:codium/domain/models/course/course_module.dart';
import 'package:codium/domain/models/course/course_pricing.dart';
import 'package:codium/domain/models/course/course_statistics.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/models/task/course_task.dart';

class Course {
  final String id;
  final String title;
  final String previewDescription;
  final String description;
  final String coverImage;
  final User author;
  final List<CourseTask> tasks;
  final List<CourseModule> modules;
  final DateTime createdAt;
  final Duration totalDuration;
  final CoursePricing pricing;
  final CourseStatistics statistics;

  late final int _totalTasks = tasks.length;
  late final Map<TaskType, int> _taskCounts = _calculateTaskCounts();

  Course({
    required this.id,
    required this.title,
    required this.previewDescription,
    required this.description,
    required this.coverImage,
    required this.author,
    required this.modules,
    required this.pricing,
    this.tasks = const [],
  })  : createdAt = DateTime.now(),
        totalDuration = _calculateTotalDuration(modules),
        statistics = CourseStatistics(
          averageRating: 0,
          totalEnrollments: 0,
          completionRate: 0,
        ) {
    _validateCourse();
  }

  int get totalTasks => _totalTasks;
  int get theoryCount => _taskCounts[TaskType.theory] ?? 0;
  int get practiceCount => _taskCounts[TaskType.practice] ?? 0;

  Map<TaskType, int> _calculateTaskCounts() {
    final counts = <TaskType, int>{};
    for (final task in tasks) {
      counts.update(task.type, (v) => v + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  static Duration _calculateTotalDuration(List<CourseModule> modules) {
    return modules.fold(
      Duration.zero,
      (sum, module) => sum + module.duration,
    );
  }

  void _validateCourse() {
    if (title.isEmpty) throw ArgumentError('Title cannot be empty');
    if (pricing.price < 0) throw ArgumentError('Price cannot be negative');
  }

  String get tableOfContents {
    final buffer = StringBuffer();
    for (final module in modules) {
      buffer.writeln('# ${module.title}');
      for (final task in module.tasks) {
        buffer.writeln('* ${task.title}');
      }
    }
    return buffer.toString();
  }
}