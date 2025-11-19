import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/domain/models/pdf_reader/pdf_reader.dart';
import 'package:drift/drift.dart';

class BookmarkLocalDataSource {
  final AppDatabase _db;

  BookmarkLocalDataSource(this._db);

  Future<List<Bookmark>> getAllBookmarks() async {
    final entities = await _db.managers.bookmarks.get();
    return entities.map(_entityToDomain).toList();
  }

  Future<Bookmark?> getBookmarkById(String id) async {
    final entity = await _db.managers.bookmarks
        .filter((f) => f.id(id))
        .getSingleOrNull();

    if (entity == null) return null;
    return _entityToDomain(entity);
  }

  Future<List<Bookmark>> getBookmarksByPdfId(String pdfBookId) async {
    final entities = await _db.managers.bookmarks
        .filter((f) => f.pdfBookId.id(pdfBookId))
        .get();

    return entities.map(_entityToDomain).toList();
  }

  Future<void> insertBookmark(Bookmark bookmark) async {
    await _db.managers.bookmarks.create(
      (o) => o(
        id: bookmark.id,
        pdfBookId: bookmark.pdfBookId,
        pageNumber: bookmark.pageNumber,
        note: Value(bookmark.note),
        createdAt: bookmark.createdAt,
      ),
    );
  }

  Future<void> updateBookmark(Bookmark bookmark) async {
    await _db.managers.bookmarks
        .filter((f) => f.id(bookmark.id))
        .update(
          (o) => o(
            pdfBookId: Value(bookmark.pdfBookId),
            pageNumber: Value(bookmark.pageNumber),
            note: Value(bookmark.note),
            createdAt: Value(bookmark.createdAt),
          ),
        );
  }

  Future<void> deleteBookmark(String id) async {
    await _db.managers.bookmarks.filter((f) => f.id(id)).delete();
  }

  Bookmark _entityToDomain(BookmarkEntity entity) {
    return Bookmark(
      id: entity.id,
      pdfBookId: entity.pdfBookId,
      pageNumber: entity.pageNumber,
      note: entity.note,
      createdAt: entity.createdAt,
    );
  }
}
