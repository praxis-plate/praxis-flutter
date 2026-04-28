import 'package:equatable/equatable.dart';
import 'package:praxis/domain/models/lesson/lesson_content_document.dart';

class CourseTask extends Equatable {
  final int id;
  final String title;
  final String description;
  final int moduleId;
  final int orderIndex;
  final Duration? estimatedTime;
  final String type;
  final String content;
  final LessonContentDocument contentDocument;

  const CourseTask({
    required this.id,
    required this.title,
    required this.description,
    required this.moduleId,
    required this.orderIndex,
    this.estimatedTime,
    this.type = 'lesson',
    this.content = '',
    required this.contentDocument,
  });

  CourseTask copyWith({
    int? id,
    String? title,
    String? description,
    int? moduleId,
    int? orderIndex,
    Duration? estimatedTime,
    String? type,
    String? content,
    LessonContentDocument? contentDocument,
  }) {
    return CourseTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      moduleId: moduleId ?? this.moduleId,
      orderIndex: orderIndex ?? this.orderIndex,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      type: type ?? this.type,
      content: content ?? this.content,
      contentDocument: contentDocument ?? this.contentDocument,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    moduleId,
    orderIndex,
    estimatedTime,
    type,
    content,
    contentDocument,
  ];

  @override
  bool get stringify => true;
}
