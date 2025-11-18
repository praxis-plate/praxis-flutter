import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final String pdfBookId;
  final int pageNumber;
  final String? note;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.pdfBookId,
    required this.pageNumber,
    this.note,
    required this.createdAt,
  });

  Bookmark copyWith({
    String? id,
    String? pdfBookId,
    int? pageNumber,
    String? note,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      pdfBookId: pdfBookId ?? this.pdfBookId,
      pageNumber: pageNumber ?? this.pageNumber,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, pdfBookId, pageNumber, note, createdAt];

  @override
  bool get stringify => true;
}
