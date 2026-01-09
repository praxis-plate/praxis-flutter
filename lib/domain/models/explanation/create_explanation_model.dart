import 'package:equatable/equatable.dart';

class CreateExplanationModel extends Equatable {
  final String selectedText;
  final String explanation;
  final String sources;

  const CreateExplanationModel({
    required this.selectedText,
    required this.explanation,
    required this.sources,
  });

  @override
  List<Object?> get props => [
    selectedText,
    explanation,
    sources,
  ];

  @override
  bool get stringify => true;
}
