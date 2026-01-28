part of 'task_model.dart';

/// Задача на сопоставление элементов
final class MatchingTaskModel extends TaskModel {
  final List<MatchingPair> pairs;
  final List<String> leftItems;
  final List<String> rightItems;

  const MatchingTaskModel({
    required super.id,
    required super.lessonId,
    required super.questionText,
    required super.correctAnswer,
    required this.pairs,
    required this.leftItems,
    required this.rightItems,
    required super.difficultyLevel,
    required super.xpValue,
    required super.orderIndex,
    super.fallbackHint,
    super.fallbackExplanation,
    required super.topic,
    required super.createdAt,
  });

  @override
  bool validateAnswer(String answer) {
    // Для matching задач ответ может быть в формате JSON или специальном формате
    // Здесь можно реализовать более сложную логику сравнения пар
    return answer.trim() == correctAnswer.trim();
  }

  @override
  String get taskType => 'matching';

  @override
  String getLocalizedTitle(
    String Function() multipleChoice,
    String Function() codeCompletion,
    String Function() matching,
    String Function() textInput,
  ) {
    return matching();
  }

  MatchingTaskModel copyWith({
    int? id,
    int? lessonId,
    String? questionText,
    String? correctAnswer,
    List<MatchingPair>? pairs,
    List<String>? leftItems,
    List<String>? rightItems,
    int? difficultyLevel,
    int? xpValue,
    int? orderIndex,
    String? fallbackHint,
    String? fallbackExplanation,
    String? topic,
    DateTime? createdAt,
  }) {
    return MatchingTaskModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      questionText: questionText ?? this.questionText,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      pairs: pairs ?? this.pairs,
      leftItems: leftItems ?? this.leftItems,
      rightItems: rightItems ?? this.rightItems,
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
  List<Object?> get props => [...super.props, pairs, leftItems, rightItems];
}

/// Модель для элемента сопоставления
class MatchingPair extends Equatable {
  final String left;
  final String right;

  const MatchingPair({required this.left, required this.right});

  @override
  List<Object?> get props => [left, right];
}
