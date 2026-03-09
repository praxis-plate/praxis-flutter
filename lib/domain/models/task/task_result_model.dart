import 'package:equatable/equatable.dart';

class TaskResultModel extends Equatable {
  final bool isCorrect;
  final int xpEarned;
  final String? explanation;
  final String? correctAnswer;

  const TaskResultModel({
    required this.isCorrect,
    required this.xpEarned,
    this.explanation,
    this.correctAnswer,
  });

  TaskResultModel copyWith({
    bool? isCorrect,
    int? xpEarned,
    String? explanation,
    String? correctAnswer,
  }) {
    return TaskResultModel(
      isCorrect: isCorrect ?? this.isCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      explanation: explanation ?? this.explanation,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  @override
  List<Object?> get props => [isCorrect, xpEarned, explanation, correctAnswer];

  @override
  bool get stringify => true;
}
