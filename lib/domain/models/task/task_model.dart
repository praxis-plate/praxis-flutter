import 'dart:convert';

import 'package:codium/domain/enums/programming_language.dart';
import 'package:codium/domain/enums/task_type.dart';
import 'package:codium/domain/models/task/test_case_model.dart';
import 'package:equatable/equatable.dart';

part 'code_completion_task_model.dart';
part 'matching_task_model.dart';
part 'multiple_choice_task_model.dart';
part 'text_input_task_model.dart';

/// Базовый класс для всех типов задач
sealed class TaskModel extends Equatable {
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

  /// Abstract method to get task type as enum
  TaskType get taskType;

  /// Abstract method to get localized title based on task type
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
