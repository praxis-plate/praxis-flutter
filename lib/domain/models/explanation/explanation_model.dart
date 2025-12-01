import 'package:equatable/equatable.dart';

class ExplanationModel extends Equatable {
  final int id;
  final int pdfBookId;
  final int pageNumber;
  final String selectedText;
  final String explanation;
  final String sources;
  final DateTime createdAt;

  const ExplanationModel({
    required this.id,
    required this.pdfBookId,
    required this.pageNumber,
    required this.selectedText,
    required this.explanation,
    required this.sources,
    required this.createdAt,
  });

  ExplanationModel copyWith({
    int? id,
    int? pdfBookId,
    int? pageNumber,
    String? selectedText,
    String? explanation,
    String? sources,
    DateTime? createdAt,
  }) {
    return ExplanationModel(
      id: id ?? this.id,
      pdfBookId: pdfBookId ?? this.pdfBookId,
      pageNumber: pageNumber ?? this.pageNumber,
      selectedText: selectedText ?? this.selectedText,
      explanation: explanation ?? this.explanation,
      sources: sources ?? this.sources,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    pdfBookId,
    pageNumber,
    selectedText,
    explanation,
    sources,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
