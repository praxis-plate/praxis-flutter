import 'package:codium/data/database/app_database.dart';

abstract interface class IBookmarkLocalDataSource {
  Future<List<BookmarkEntity>> getAllBookmarks();

  Future<BookmarkEntity?> getBookmarkById(int id);

  Future<List<BookmarkEntity>> getBookmarksByPdfId(int pdfBookId);

  Future<BookmarkEntity> insertBookmark(BookmarkCompanion bookmark);

  Future<void> updateBookmark(BookmarkCompanion bookmark);

  Future<void> deleteBookmark(int id);
}
