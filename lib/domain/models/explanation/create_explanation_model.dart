import 'package:equatable/equatable.dart';

class CreateExplanationModel extends Equatable {
  final int pdfBookId;
  final int pageNumber;
  final String selectedText;
  final String explanation;
  final String sources;

  const CreateExplanationModel({
    required this.pdfBookId,
    required this.pageNumber,
    required this.selectedText,
    required this.explanation,
    required this.sources,
  });

  @override
  List<Object?> get props => [
    pdfBookId,
    pageNumber,
    selectedText,
    explanation,
    sources,
  ];

  @override
  bool get stringify => true;
}
