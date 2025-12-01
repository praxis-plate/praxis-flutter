import 'package:codium/data/database/app_database.dart';

abstract interface class IPdfLocalDataSource {
  Future<List<PdfBookEntity>> getAllBooks();
  Future<PdfBookEntity?> getBookById(int id);
  Future<PdfBookEntity> insertBook(PdfBookCompanion entry);
  Future<void> updateBook(PdfBookCompanion entry);
  Future<void> deleteBook(int id);
}
