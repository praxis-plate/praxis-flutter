import 'package:equatable/equatable.dart';

class TaskOptionModel extends Equatable {
  final int id;
  final int taskId;
  final String optionText;
  final bool isCorrect;
  final int orderIndex;

  const TaskOptionModel({
    required this.id,
    required this.taskId,
    required this.optionText,
    required this.isCorrect,
    required this.orderIndex,
  });

  TaskOptionModel copyWith({
    int? id,
    int? taskId,
    String? optionText,
    bool? isCorrect,
    int? orderIndex,
  }) {
    return TaskOptionModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      optionText: optionText ?? this.optionText,
      isCorrect: isCorrect ?? this.isCorrect,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  List<Object?> get props => [id, taskId, optionText, isCorrect, orderIndex];

  @override
  bool get stringify => true;
}
