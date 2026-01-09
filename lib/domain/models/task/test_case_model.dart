import 'package:equatable/equatable.dart';

class TestCaseModel extends Equatable {
  final int id;
  final int taskId;
  final String input;
  final String expectedOutput;
  final bool isHidden;
  final int orderIndex;

  const TestCaseModel({
    required this.id,
    required this.taskId,
    required this.input,
    required this.expectedOutput,
    required this.isHidden,
    required this.orderIndex,
  });

  TestCaseModel copyWith({
    int? id,
    int? taskId,
    String? input,
    String? expectedOutput,
    bool? isHidden,
    int? orderIndex,
  }) {
    return TestCaseModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      input: input ?? this.input,
      expectedOutput: expectedOutput ?? this.expectedOutput,
      isHidden: isHidden ?? this.isHidden,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  List<Object?> get props => [
    id,
    taskId,
    input,
    expectedOutput,
    isHidden,
    orderIndex,
  ];

  @override
  bool get stringify => true;
}
