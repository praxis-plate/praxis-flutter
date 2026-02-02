import 'package:codium/domain/enums/programming_language.dart';
import 'package:codium/domain/models/task/task_model.dart';
import 'package:codium/domain/models/task/test_case_model.dart';
import 'package:praxis_client/praxis_client.dart';

extension TaskDtoExtension on TaskDto {
  TaskModel toDomain() {
    switch (taskType) {
      case TaskType.multipleChoice:
        return MultipleChoiceTaskModel(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          options: options.map((o) => o.optionText).toList(),
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
        );
      case TaskType.codeCompletion:
        return CodeCompletionTaskModel(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          codeTemplate: codeTemplate ?? '',
          language: ProgrammingLanguage.values.firstWhere(
            (lang) => lang.name == programmingLanguage,
            orElse: () => ProgrammingLanguage.dart,
          ),
          testCases: testCases
              .map(
                (tc) => TestCaseModel(
                  id: tc.id,
                  taskId: tc.taskId,
                  input: tc.input,
                  expectedOutput: tc.expectedOutput,
                  isHidden: false,
                  orderIndex: 0,
                ),
              )
              .toList(),
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
        );
      case TaskType.textInput:
        return TextInputTaskModel(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
        );
      case TaskType.matching:
        return MatchingTaskModel.fromMatchingData(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          correctAnswer: correctAnswer,
          difficultyLevel: difficultyLevel,
          xpValue: xpValue,
          orderIndex: orderIndex,
          fallbackHint: fallbackHint,
          fallbackExplanation: fallbackExplanation,
          topic: topic,
          createdAt: createdAt,
          matchingDataJson: optionsJson,
        );
    }
  }
}
