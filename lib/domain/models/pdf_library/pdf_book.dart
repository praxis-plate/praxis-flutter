import 'package:equatable/equatable.dart';

class PdfBook extends Equatable {
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

  final String id;
  final String title;
  final String? author;
  final String filePath;
  final int totalPages;
  final int currentPage;
  final DateTime? lastRead;
  final bool isFavorite;

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

  factory PdfBook.fromJson(Map<String, dynamic> json) {
    return PdfBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      filePath: json['filePath'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      lastRead: DateTime.fromMillisecondsSinceEpoch(json['lastRead']),
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'filePath': filePath,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'lastRead': lastRead?.millisecondsSinceEpoch,
      'isFavorite': isFavorite,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      author,
      filePath,
      totalPages,
      currentPage,
      lastRead,
      isFavorite,
    ];
  }
}
