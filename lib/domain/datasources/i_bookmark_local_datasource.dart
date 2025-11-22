import 'package:codium/domain/models/pdf_reader/pdf_reader.dart';

abstract interface class IBookmarkLocalDataSource {
  Future<List<Bookmark>> getAllBookmarks();

  Future<Bookmark?> getBookmarkById(String id);

  Future<List<Bookmark>> getBookmarksByPdfId(String pdfBookId);

  Future<void> insertBookmark(Bookmark bookmark);

  Future<void> updateBookmark(Bookmark bookmark);

  Future<void> deleteBookmark(String id);
}
