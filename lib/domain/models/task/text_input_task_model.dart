part of 'task_model.dart';

final class TextInputTaskModel extends TaskModel {
  final bool caseSensitive;
  final bool exactMatch;
  final List<String>? acceptableAnswers;

  const TextInputTaskModel({
    required super.id,
    required super.lessonId,
    required super.questionText,
    required super.correctAnswer,
    required super.difficultyLevel,
    required super.xpValue,
    required super.orderIndex,
    required super.topic,
    required super.createdAt,
    this.caseSensitive = false,
    this.exactMatch = false,
    this.acceptableAnswers,
    super.fallbackHint,
    super.fallbackExplanation,
  });

  @override
  TaskType get taskType => TaskType.textInput;

  @override
  String getLocalizedTitle(
    String Function() multipleChoice,
    String Function() codeCompletion,
    String Function() matching,
    String Function() textInput,
  ) {
    return textInput();
  }

  TextInputTaskModel copyWith({
    int? id,
    int? lessonId,
    String? questionText,
    String? correctAnswer,
    bool? caseSensitive,
    bool? exactMatch,
    List<String>? acceptableAnswers,
    int? difficultyLevel,
    int? xpValue,
    int? orderIndex,
    String? fallbackHint,
    String? fallbackExplanation,
    String? topic,
    DateTime? createdAt,
  }) {
    return TextInputTaskModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      questionText: questionText ?? this.questionText,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      exactMatch: exactMatch ?? this.exactMatch,
      acceptableAnswers: acceptableAnswers ?? this.acceptableAnswers,
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
  List<Object?> get props => [
    ...super.props,
    caseSensitive,
    exactMatch,
    acceptableAnswers,
  ];
}
