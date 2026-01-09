import 'package:equatable/equatable.dart';

class TestCaseResultModel extends Equatable {
  final String input;
  final String expectedOutput;
  final String actualOutput;
  final bool passed;

  const TestCaseResultModel({
    required this.input,
    required this.expectedOutput,
    required this.actualOutput,
    required this.passed,
  });

  @override
  List<Object?> get props => [input, expectedOutput, actualOutput, passed];

  @override
  bool get stringify => true;
}
