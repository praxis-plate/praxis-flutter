import 'package:equatable/equatable.dart';

/// Базовый абстрактный класс для всех типов задач
abstract class TaskModel extends Equatable {
  final int id;
  final int lessonId;
  final String questionText;
  final String correctAnswer;
  final int difficultyLevel;
  final int xpValue;
  final int orderIndex;
  final String? fallbackHint;
  final String? fallbackExplanation;
  final String topic;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.lessonId,
    required this.questionText,
    required this.correctAnswer,
    required this.difficultyLevel,
    required this.xpValue,
    required this.orderIndex,
    this.fallbackHint,
    this.fallbackExplanation,
    required this.topic,
    required this.createdAt,
  });

  /// Абстрактный метод для валидации ответа
  /// Каждый тип задачи реализует свою логику валидации
  bool validateAnswer(String answer);

  /// Абстрактный метод для получения типа задачи как строки
  String get taskType;

  /// Абстрактный метод для получения локализованного названия типа
  String getLocalizedTitle(
    String Function() multipleChoice,
    String Function() codeCompletion,
    String Function() matching,
    String Function() textInput,
  );

  @override
  List<Object?> get props => [
    id,
    lessonId,
    questionText,
    correctAnswer,
    difficultyLevel,
    xpValue,
    orderIndex,
    fallbackHint,
    fallbackExplanation,
    topic,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
