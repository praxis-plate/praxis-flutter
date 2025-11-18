import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/models/pdf_reader/bookmark.dart';

abstract interface class IPdfRepository {
  Future<List<PdfBook>> getAllBooks();
  Future<PdfBook?> getBookById(String id);
  Future<void> importPdf(String filePath);
  Future<void> updateReadingProgress(String bookId, int page);
  Future<void> deleteBook(String bookId);

  Future<List<Bookmark>> getBookmarks(String bookId);
  Future<void> addBookmark(Bookmark bookmark);
  Future<void> deleteBookmark(String bookmarkId);
}
