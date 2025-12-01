import 'package:equatable/equatable.dart';

class UpdatePdfBookModel extends Equatable {
  final int id;
  final String? title;
  final String? author;
  final int? currentPage;
  final DateTime? lastRead;
  final bool? isFavorite;

  const UpdatePdfBookModel({
    required this.id,
    this.title,
    this.author,
    this.currentPage,
    this.lastRead,
    this.isFavorite,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    currentPage,
    lastRead,
    isFavorite,
  ];

  @override
  bool get stringify => true;
}
