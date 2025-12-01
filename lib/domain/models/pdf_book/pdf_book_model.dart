import 'package:equatable/equatable.dart';

class PdfBookModel extends Equatable {
  final int id;
  final String title;
  final String? author;
  final String filePath;
  final int totalPages;
  final int currentPage;
  final DateTime? lastRead;
  final bool isFavorite;

  const PdfBookModel({
    required this.id,
    required this.title,
    this.author,
    required this.filePath,
    required this.totalPages,
    required this.currentPage,
    this.lastRead,
    required this.isFavorite,
  });

  PdfBookModel copyWith({
    int? id,
    String? title,
    String? author,
    String? filePath,
    int? totalPages,
    int? currentPage,
    DateTime? lastRead,
    bool? isFavorite,
  }) {
    return PdfBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      filePath: filePath ?? this.filePath,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      lastRead: lastRead ?? this.lastRead,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    filePath,
    totalPages,
    currentPage,
    lastRead,
    isFavorite,
  ];

  @override
  bool get stringify => true;
}
