import 'package:equatable/equatable.dart';

class BookmarkModel extends Equatable {
  final int id;
  final int pdfBookId;
  final int pageNumber;
  final String? note;
  final DateTime createdAt;

  const BookmarkModel({
    required this.id,
    required this.pdfBookId,
    required this.pageNumber,
    this.note,
    required this.createdAt,
  });

  BookmarkModel copyWith({
    int? id,
    int? pdfBookId,
    int? pageNumber,
    String? note,
    DateTime? createdAt,
  }) {
    return BookmarkModel(
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
