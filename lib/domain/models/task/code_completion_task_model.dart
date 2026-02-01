part of 'task_model.dart';

/// Задача на дополнение кода
final class CodeCompletionTaskModel extends TaskModel {
  final String codeTemplate;
  final List<TestCaseModel> testCases;
  final ProgrammingLanguage language;

  const CodeCompletionTaskModel({
    required super.id,
    required super.lessonId,
    required super.questionText,
    required super.correctAnswer,
    required this.codeTemplate,
    required this.testCases,
    required this.language,
    required super.difficultyLevel,
    required super.xpValue,
    required super.orderIndex,
    super.fallbackHint,
    super.fallbackExplanation,
    required super.topic,
    required super.createdAt,
  });

  @override
  TaskType get taskType => TaskType.codeCompletion;

  @override
  String getLocalizedTitle(
    String Function() multipleChoice,
    String Function() codeCompletion,
    String Function() matching,
    String Function() textInput,
  ) {
    return codeCompletion();
  }

  CodeCompletionTaskModel copyWith({
    int? id,
    int? lessonId,
    String? questionText,
    String? correctAnswer,
    String? codeTemplate,
    List<TestCaseModel>? testCases,
    ProgrammingLanguage? language,
    int? difficultyLevel,
    int? xpValue,
    int? orderIndex,
    String? fallbackHint,
    String? fallbackExplanation,
    String? topic,
    DateTime? createdAt,
  }) {
    return CodeCompletionTaskModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      questionText: questionText ?? this.questionText,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      codeTemplate: codeTemplate ?? this.codeTemplate,
      testCases: testCases ?? this.testCases,
      language: language ?? this.language,
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
    codeTemplate,
    testCases,
    language,
  ];
}
