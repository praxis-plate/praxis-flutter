part of 'task_model.dart';

/// Задача с множественным выбором
final class MultipleChoiceTaskModel extends TaskModel {
  final List<String> options;
  final TaskType taskTypeValue;

  const MultipleChoiceTaskModel({
    required super.id,
    required super.lessonId,
    required super.questionText,
    required super.correctAnswer,
    required this.options,
    this.taskTypeValue = TaskType.multipleChoice,
    required super.difficultyLevel,
    required super.xpValue,
    required super.orderIndex,
    super.fallbackHint,
    super.fallbackExplanation,
    required super.topic,
    required super.createdAt,
  });

  @override
  TaskType get taskType => taskTypeValue;

  @override
  String getLocalizedTitle(
    String Function() multipleChoice,
    String Function() codeCompletion,
    String Function() matching,
    String Function() textInput,
  ) {
    return multipleChoice();
  }

  MultipleChoiceTaskModel copyWith({
    int? id,
    int? lessonId,
    String? questionText,
    String? correctAnswer,
    List<String>? options,
    TaskType? taskTypeValue,
    int? difficultyLevel,
    int? xpValue,
    int? orderIndex,
    String? fallbackHint,
    String? fallbackExplanation,
    String? topic,
    DateTime? createdAt,
  }) {
    return MultipleChoiceTaskModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      questionText: questionText ?? this.questionText,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      options: options ?? this.options,
      taskTypeValue: taskTypeValue ?? this.taskTypeValue,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      xpValue: xpValue ?? this.xpValue,
      orderIndex: orderIndex ?? this.orderIndex,
      fallbackHint: fallbackHint ?? this.fallbackHint,
      fallbackExplanation: fallbackExplanation ?? this.fallbackExplanation,
      topic: topic ?? this.topic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [...super.props, options, taskTypeValue];
}
