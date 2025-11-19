import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/data/datasources/local/pdf_local_datasource.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late PdfLocalDataSource dataSource;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = PdfLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('PdfLocalDataSource', () {
    test('should insert and retrieve a PDF book', () async {
      const book = PdfBook(
        id: 'book1',
        title: 'Test Book',
        author: 'Test Author',
        filePath: '/path/to/book.pdf',
        totalPages: 100,
        currentPage: 0,
        isFavorite: false,
      );

      await dataSource.insertBook(book);

      final retrieved = await dataSource.getBookById('book1');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, book.id);
      expect(retrieved.title, book.title);
      expect(retrieved.author, book.author);
      expect(retrieved.filePath, book.filePath);
      expect(retrieved.totalPages, book.totalPages);
      expect(retrieved.currentPage, book.currentPage);
      expect(retrieved.isFavorite, book.isFavorite);
    });

    test('should get all books', () async {
      const book1 = PdfBook(
        id: 'book1',
        title: 'Book 1',
        filePath: '/path/to/book1.pdf',
        totalPages: 100,
      );

      const book2 = PdfBook(
        id: 'book2',
        title: 'Book 2',
        filePath: '/path/to/book2.pdf',
        totalPages: 200,
      );

      await dataSource.insertBook(book1);
      await dataSource.insertBook(book2);

      final books = await dataSource.getAllBooks();

      expect(books.length, 2);
      expect(books.any((b) => b.id == 'book1'), true);
      expect(books.any((b) => b.id == 'book2'), true);
    });

    test('should update a book', () async {
      const book = PdfBook(
        id: 'book1',
        title: 'Test Book',
        filePath: '/path/to/book.pdf',
        totalPages: 100,
        currentPage: 0,
      );

      await dataSource.insertBook(book);

      final updatedBook = book.copyWith(currentPage: 50, isFavorite: true);

      await dataSource.updateBook(updatedBook);

      final retrieved = await dataSource.getBookById('book1');

      expect(retrieved!.currentPage, 50);
      expect(retrieved.isFavorite, true);
    });

    test('should delete a book', () async {
      const book = PdfBook(
        id: 'book1',
        title: 'Test Book',
        filePath: '/path/to/book.pdf',
        totalPages: 100,
      );

      await dataSource.insertBook(book);
      await dataSource.deleteBook('book1');

      final retrieved = await dataSource.getBookById('book1');

      expect(retrieved, isNull);
    });

    test('should return null for non-existent book', () async {
      final retrieved = await dataSource.getBookById('nonexistent');

      expect(retrieved, isNull);
    });

    test('should preserve lastRead timestamp', () async {
      final now = DateTime.now();
      final book = PdfBook(
        id: 'book1',
        title: 'Test Book',
        filePath: '/path/to/book.pdf',
        totalPages: 100,
        lastRead: now,
      );

      await dataSource.insertBook(book);

      final retrieved = await dataSource.getBookById('book1');

      expect(retrieved!.lastRead, isNotNull);
      expect(retrieved.lastRead!.difference(now).inSeconds, lessThan(1));
    });
  });
}
