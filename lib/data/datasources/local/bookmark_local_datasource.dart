import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_bookmark_local_datasource.dart';

class BookmarkLocalDataSource implements IBookmarkLocalDataSource {
  final AppDatabase _db;

  const BookmarkLocalDataSource(this._db);

  @override
  Future<List<BookmarkEntity>> getAllBookmarks() async {
    return await _db.managers.bookmark.get();
  }

  @override
  Future<BookmarkEntity?> getBookmarkById(int id) async {
    return await _db.managers.bookmark
        .filter((f) => f.id(id))
        .getSingleOrNull();
  }

  @override
  Future<List<BookmarkEntity>> getBookmarksByPdfId(int pdfBookId) async {
    return await _db.managers.bookmark
        .filter((f) => f.pdfBookId.id(pdfBookId))
        .get();
  }

  @override
  Future<BookmarkEntity> insertBookmark(BookmarkCompanion entry) async {
    return await _db.into(_db.bookmark).insertReturning(entry);
  }

  @override
  Future<void> updateBookmark(BookmarkCompanion bookmark) async {
    if (!bookmark.id.present) {
      throw ArgumentError('Bookmark id must be present for update');
    }

    final int id = bookmark.id.value;

    await (_db.update(
      _db.bookmark,
    )..where((t) => t.id.equals(id))).write(bookmark);
  }

  @override
  Future<void> deleteBookmark(int id) async {
    await _db.managers.bookmark.filter((f) => f.id(id)).delete();
  }
}
