import 'package:codium/domain/enums/task_type.dart';

abstract class CourseTask {
  final String id;
  final String title;
  final String content;
  final TaskType type;
  final DateTime createdAt;
  final Duration? estimatedTime;

  CourseTask({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.estimatedTime,
  }) : createdAt = DateTime.now();

  String renderContent() => content;
}