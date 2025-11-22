import 'package:codium/domain/models/pdf_library/pdf_library.dart';

abstract interface class IPdfLocalDataSource {
  Future<List<PdfBook>> getAllBooks();

  Future<PdfBook?> getBookById(String id);

  Future<void> insertBook(PdfBook book);

  Future<void> updateBook(PdfBook book);

  Future<void> deleteBook(String id);
}
