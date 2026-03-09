import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/entities/task_entity_extension.dart';
import 'package:codium/domain/enums/task_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps snake_case task type from local entity to domain enum', () {
    final entity = TaskEntity(
      id: 1,
      lessonId: 10,
      taskType: 'code_completion',
      questionText: 'Complete the function',
      correctAnswer: 'return 42;',
      optionsJson: null,
      codeTemplate: 'int answer() { }',
      testCasesJson: '[]',
      programmingLanguage: 'dart',
      difficultyLevel: 1,
      xpValue: 10,
      orderIndex: 0,
      fallbackHint: null,
      fallbackExplanation: null,
      topic: 'functions',
      createdAt: DateTime(2026, 3, 9),
    );

    final model = entity.toDomain();

    expect(model.taskType, TaskType.codeCompletion);
  });
}
