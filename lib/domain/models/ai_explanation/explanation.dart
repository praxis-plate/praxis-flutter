import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:equatable/equatable.dart';

class Explanation extends Equatable {
  const Explanation({
    required this.id,
    required this.pdfBookId,
    required this.pageNumber,
    required this.selectedText,
    required this.explanation,
    this.sources = const [],
    required this.createdAt,
  });

  final String id;
  final String pdfBookId;
  final int pageNumber;
  final String selectedText;
  final String explanation;
  final List<SearchSource> sources;
  final DateTime createdAt;

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

  factory Explanation.fromJson(Map<String, dynamic> json) {
    return Explanation(
      id: json['id'],
      pdfBookId: json['pdfBookId'],
      pageNumber: json['pageNumber'],
      selectedText: json['selectedText'],
      explanation: json['explanation'],
      sources: List<SearchSource>.from(
        json['sources']?.map((x) => SearchSource.fromJson(x)),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pdfBookId': pdfBookId,
      'pageNumber': pageNumber,
      'selectedText': selectedText,
      'explanation': explanation,
      'sources': sources.map((x) => x.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      pdfBookId,
      pageNumber,
      selectedText,
      explanation,
      sources,
      createdAt,
    ];
  }
}
