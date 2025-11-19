import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  const Bookmark({
    required this.id,
    required this.pdfBookId,
    required this.pageNumber,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String pdfBookId;
  final int pageNumber;
  final String? note;
  final DateTime createdAt;

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

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      pdfBookId: json['pdfBookId'],
      pageNumber: json['pageNumber'],
      note: json['note'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pdfBookId': pdfBookId,
      'pageNumber': pageNumber,
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props {
    return [id, pdfBookId, pageNumber, note, createdAt];
  }
}
