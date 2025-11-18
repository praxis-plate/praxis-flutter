import 'package:equatable/equatable.dart';

class PdfBook extends Equatable {
  final String id;
  final String title;
  final String? author;
  final String filePath;
  final int totalPages;
  final int currentPage;
  final DateTime? lastRead;
  final bool isFavorite;

  const PdfBook({
    required this.id,
    required this.title,
    this.author,
    required this.filePath,
    required this.totalPages,
    this.currentPage = 0,
    this.lastRead,
    this.isFavorite = false,
  });

  bool isValid() {
    return id.isNotEmpty &&
        title.isNotEmpty &&
        filePath.isNotEmpty &&
        totalPages > 0 &&
        currentPage >= 0 &&
        currentPage <= totalPages;
  }

  PdfBook copyWith({
    String? id,
    String? title,
    String? author,
    String? filePath,
    int? totalPages,
    int? currentPage,
    DateTime? lastRead,
    bool? isFavorite,
  }) {
    return PdfBook(
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
