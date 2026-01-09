import 'package:codium/domain/models/task/test_case_result_model.dart';
import 'package:equatable/equatable.dart';

class TaskResultModel extends Equatable {
  final bool isCorrect;
  final int xpEarned;
  final String? explanation;
  final String? correctAnswer;
  final List<TestCaseResultModel>? testResults;

  const TaskResultModel({
    required this.isCorrect,
    required this.xpEarned,
    this.explanation,
    this.correctAnswer,
    this.testResults,
  });

  TaskResultModel copyWith({
    bool? isCorrect,
    int? xpEarned,
    String? explanation,
    String? correctAnswer,
    List<TestCaseResultModel>? testResults,
  }) {
    return TaskResultModel(
      isCorrect: isCorrect ?? this.isCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      explanation: explanation ?? this.explanation,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      testResults: testResults ?? this.testResults,
    );
  }

  @override
  List<Object?> get props => [
    isCorrect,
    xpEarned,
    explanation,
    correctAnswer,
    testResults,
  ];

  @override
  bool get stringify => true;
}
