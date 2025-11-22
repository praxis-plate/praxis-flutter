import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/data/datasources/local/bookmark_local_datasource.dart';
import 'package:codium/domain/models/pdf_reader/bookmark.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late BookmarkLocalDataSource dataSource;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = BookmarkLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('BookmarkLocalDataSource', () {
    setUp(() async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );
    });

    test('should insert and retrieve a bookmark', () async {
      final now = DateTime.now();
      final bookmark = Bookmark(
        id: 'bookmark1',
        pdfBookId: 'book1',
        pageNumber: 42,
        note: 'Important page',
        createdAt: now,
      );

      await dataSource.insertBookmark(bookmark);

      final retrieved = await dataSource.getBookmarkById('bookmark1');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, bookmark.id);
      expect(retrieved.pdfBookId, bookmark.pdfBookId);
      expect(retrieved.pageNumber, bookmark.pageNumber);
      expect(retrieved.note, bookmark.note);
      expect(retrieved.createdAt.difference(now).inSeconds, lessThan(1));
    });

    test('should get bookmarks by PDF book id', () async {
      final now = DateTime.now();
      final bookmark1 = Bookmark(
        id: 'bookmark1',
        pdfBookId: 'book1',
        pageNumber: 10,
        createdAt: now,
      );

      final bookmark2 = Bookmark(
        id: 'bookmark2',
        pdfBookId: 'book1',
        pageNumber: 20,
        createdAt: now,
      );

      await dataSource.insertBookmark(bookmark1);
      await dataSource.insertBookmark(bookmark2);

      final bookmarks = await dataSource.getBookmarksByPdfId('book1');

      expect(bookmarks.length, 2);
      expect(bookmarks.any((b) => b.id == 'bookmark1'), true);
      expect(bookmarks.any((b) => b.id == 'bookmark2'), true);
    });

    test('should get all bookmarks', () async {
      final now = DateTime.now();
      final bookmark1 = Bookmark(
        id: 'bookmark1',
        pdfBookId: 'book1',
        pageNumber: 10,
        createdAt: now,
      );

      final bookmark2 = Bookmark(
        id: 'bookmark2',
        pdfBookId: 'book1',
        pageNumber: 20,
        createdAt: now,
      );

      await dataSource.insertBookmark(bookmark1);
      await dataSource.insertBookmark(bookmark2);

      final bookmarks = await dataSource.getAllBookmarks();

      expect(bookmarks.length, 2);
    });

    test('should update a bookmark', () async {
      final now = DateTime.now();
      final bookmark = Bookmark(
        id: 'bookmark1',
        pdfBookId: 'book1',
        pageNumber: 42,
        createdAt: now,
      );

      await dataSource.insertBookmark(bookmark);

      final updatedBookmark = bookmark.copyWith(note: 'Updated note');

      await dataSource.updateBookmark(updatedBookmark);

      final retrieved = await dataSource.getBookmarkById('bookmark1');

      expect(retrieved!.note, 'Updated note');
    });

    test('should delete a bookmark', () async {
      final now = DateTime.now();
      final bookmark = Bookmark(
        id: 'bookmark1',
        pdfBookId: 'book1',
        pageNumber: 42,
        createdAt: now,
      );

      await dataSource.insertBookmark(bookmark);
      await dataSource.deleteBookmark('bookmark1');

      final retrieved = await dataSource.getBookmarkById('bookmark1');

      expect(retrieved, isNull);
    });

    test('should return null for non-existent bookmark', () async {
      final retrieved = await dataSource.getBookmarkById('nonexistent');

      expect(retrieved, isNull);
    });

    test('should handle bookmarks without notes', () async {
      final now = DateTime.now();
      final bookmark = Bookmark(
        id: 'bookmark1',
        pdfBookId: 'book1',
        pageNumber: 42,
        createdAt: now,
      );

      await dataSource.insertBookmark(bookmark);

      final retrieved = await dataSource.getBookmarkById('bookmark1');

      expect(retrieved!.note, isNull);
    });
  });
}
