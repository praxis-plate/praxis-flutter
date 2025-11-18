import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:equatable/equatable.dart';

class Explanation extends Equatable {
  final String id;
  final String pdfBookId;
  final int pageNumber;
  final String selectedText;
  final String explanation;
  final List<SearchSource> sources;
  final DateTime createdAt;

  const Explanation({
    required this.id,
    required this.pdfBookId,
    required this.pageNumber,
    required this.selectedText,
    required this.explanation,
    this.sources = const [],
    required this.createdAt,
  });

  Explanation copyWith({
    String? id,
    String? pdfBookId,
    int? pageNumber,
    String? selectedText,
    String? explanation,
    List<SearchSource>? sources,
    DateTime? createdAt,
  }) {
    return Explanation(
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
