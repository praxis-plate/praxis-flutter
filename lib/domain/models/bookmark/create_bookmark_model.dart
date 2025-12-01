import 'package:equatable/equatable.dart';

class CreateBookmarkModel extends Equatable {
  final int pdfBookId;
  final int pageNumber;
  final String? note;

  const CreateBookmarkModel({
    required this.pdfBookId,
    required this.pageNumber,
    this.note,
  });

  @override
  List<Object?> get props => [pdfBookId, pageNumber, note];

  @override
  bool get stringify => true;
}
