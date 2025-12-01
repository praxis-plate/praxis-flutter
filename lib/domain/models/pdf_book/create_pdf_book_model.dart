import 'package:equatable/equatable.dart';

class CreatePdfBookModel extends Equatable {
  final String title;
  final String? author;
  final String filePath;
  final int totalPages;

  const CreatePdfBookModel({
    required this.title,
    this.author,
    required this.filePath,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [title, author, filePath, totalPages];

  @override
  bool get stringify => true;
}
