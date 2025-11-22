import 'package:codium/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('PdfBooks CRUD Operations', () {
    test('should insert a PDF book', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          author: const Value('Test Author'),
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );

      final books = await database.managers.pdfBooks.get();
      expect(books.length, 1);
      expect(books.first.id, 'book1');
      expect(books.first.title, 'Test Book');
      expect(books.first.author, 'Test Author');
      expect(books.first.totalPages, 100);
      expect(books.first.currentPage, 0);
      expect(books.first.isFavorite, false);
    });

    test('should get a PDF book by id', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );

      final book = await database.managers.pdfBooks
          .filter((f) => f.id('book1'))
          .getSingleOrNull();

      expect(book != null, true);
      expect(book!.id, 'book1');
      expect(book.title, 'Test Book');
    });

    test('should update a PDF book', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.pdfBooks
          .filter((f) => f.id('book1'))
          .update(
            (o) =>
                o(currentPage: const Value(50), isFavorite: const Value(true)),
          );

      final book = await database.managers.pdfBooks
          .filter((f) => f.id('book1'))
          .getSingleOrNull();

      expect(book!.currentPage, 50);
      expect(book.isFavorite, true);
    });

    test('should delete a PDF book', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.pdfBooks.filter((f) => f.id('book1')).delete();

      final books = await database.managers.pdfBooks.get();
      expect(books.length, 0);
    });

    test('should get all PDF books', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Book 1',
          filePath: '/path/to/book1.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book2',
          title: 'Book 2',
          filePath: '/path/to/book2.pdf',
          totalPages: 200,
        ),
      );

      final books = await database.managers.pdfBooks.get();
      expect(books.length, 2);
    });

    test('should filter PDF books by favorite status', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Book 1',
          filePath: '/path/to/book1.pdf',
          totalPages: 100,
          isFavorite: const Value(true),
        ),
      );

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book2',
          title: 'Book 2',
          filePath: '/path/to/book2.pdf',
          totalPages: 200,
          isFavorite: const Value(false),
        ),
      );

      final favoriteBooks = await database.managers.pdfBooks
          .filter((f) => f.isFavorite(true))
          .get();

      expect(favoriteBooks.length, 1);
      expect(favoriteBooks.first.id, 'book1');
    });
  });

  group('Bookmarks CRUD Operations', () {
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

    test('should insert a bookmark', () async {
      final now = DateTime.now();
      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark1',
          pdfBookId: 'book1',
          pageNumber: 42,
          note: const Value('Important page'),
          createdAt: now,
        ),
      );

      final bookmarks = await database.managers.bookmarks.get();
      expect(bookmarks.length, 1);
      expect(bookmarks.first.id, 'bookmark1');
      expect(bookmarks.first.pdfBookId, 'book1');
      expect(bookmarks.first.pageNumber, 42);
      expect(bookmarks.first.note, 'Important page');
    });

    test('should get bookmarks by PDF book id', () async {
      final now = DateTime.now();
      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark1',
          pdfBookId: 'book1',
          pageNumber: 42,
          createdAt: now,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark2',
          pdfBookId: 'book1',
          pageNumber: 84,
          createdAt: now,
        ),
      );

      final bookmarks = await database.managers.bookmarks
          .filter((f) => f.pdfBookId.id('book1'))
          .get();

      expect(bookmarks.length, 2);
    });

    test('should update a bookmark', () async {
      final now = DateTime.now();
      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark1',
          pdfBookId: 'book1',
          pageNumber: 42,
          createdAt: now,
        ),
      );

      await database.managers.bookmarks
          .filter((f) => f.id('bookmark1'))
          .update((o) => o(note: const Value('Updated note')));

      final bookmark = await database.managers.bookmarks
          .filter((f) => f.id('bookmark1'))
          .getSingleOrNull();

      expect(bookmark!.note, 'Updated note');
    });

    test('should delete a bookmark', () async {
      final now = DateTime.now();
      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark1',
          pdfBookId: 'book1',
          pageNumber: 42,
          createdAt: now,
        ),
      );

      await database.managers.bookmarks
          .filter((f) => f.id('bookmark1'))
          .delete();

      final bookmarks = await database.managers.bookmarks.get();
      expect(bookmarks.length, 0);
    });
  });

  group('Explanations CRUD Operations', () {
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

    test('should insert an explanation', () async {
      final now = DateTime.now();
      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation1',
          pdfBookId: 'book1',
          pageNumber: 10,
          selectedText: 'polymorphism',
          explanation: 'Polymorphism is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      final explanations = await database.managers.explanations.get();
      expect(explanations.length, 1);
      expect(explanations.first.id, 'explanation1');
      expect(explanations.first.selectedText, 'polymorphism');
      expect(explanations.first.explanation, 'Polymorphism is...');
    });

    test('should get explanations by PDF book id', () async {
      final now = DateTime.now();
      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation1',
          pdfBookId: 'book1',
          pageNumber: 10,
          selectedText: 'polymorphism',
          explanation: 'Polymorphism is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation2',
          pdfBookId: 'book1',
          pageNumber: 20,
          selectedText: 'inheritance',
          explanation: 'Inheritance is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      final explanations = await database.managers.explanations
          .filter((f) => f.pdfBookId.id('book1'))
          .get();

      expect(explanations.length, 2);
    });

    test('should delete an explanation', () async {
      final now = DateTime.now();
      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation1',
          pdfBookId: 'book1',
          pageNumber: 10,
          selectedText: 'polymorphism',
          explanation: 'Polymorphism is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      await database.managers.explanations
          .filter((f) => f.id('explanation1'))
          .delete();

      final explanations = await database.managers.explanations.get();
      expect(explanations.length, 0);
    });

    test('should filter explanations by page number', () async {
      final now = DateTime.now();
      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation1',
          pdfBookId: 'book1',
          pageNumber: 10,
          selectedText: 'polymorphism',
          explanation: 'Polymorphism is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation2',
          pdfBookId: 'book1',
          pageNumber: 20,
          selectedText: 'inheritance',
          explanation: 'Inheritance is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      final explanations = await database.managers.explanations
          .filter((f) => f.pageNumber(10))
          .get();

      expect(explanations.length, 1);
      expect(explanations.first.pageNumber, 10);
    });
  });

  group('Cascade Delete Operations', () {
    test('should cascade delete bookmarks when PDF book is deleted', () async {
      final now = DateTime.now();

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark1',
          pdfBookId: 'book1',
          pageNumber: 42,
          createdAt: now,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark2',
          pdfBookId: 'book1',
          pageNumber: 84,
          createdAt: now,
        ),
      );

      await database.managers.pdfBooks.filter((f) => f.id('book1')).delete();

      final bookmarks = await database.managers.bookmarks.get();
      expect(bookmarks.length, 0);
    });

    test(
      'should cascade delete explanations when PDF book is deleted',
      () async {
        final now = DateTime.now();

        await database.managers.pdfBooks.create(
          (o) => o(
            id: 'book1',
            title: 'Test Book',
            filePath: '/path/to/book.pdf',
            totalPages: 100,
          ),
        );

        await database.managers.explanations.create(
          (o) => o(
            id: 'explanation1',
            pdfBookId: 'book1',
            pageNumber: 10,
            selectedText: 'polymorphism',
            explanation: 'Polymorphism is...',
            sources: '[]',
            createdAt: now,
          ),
        );

        await database.managers.explanations.create(
          (o) => o(
            id: 'explanation2',
            pdfBookId: 'book1',
            pageNumber: 20,
            selectedText: 'inheritance',
            explanation: 'Inheritance is...',
            sources: '[]',
            createdAt: now,
          ),
        );

        await database.managers.pdfBooks.filter((f) => f.id('book1')).delete();

        final explanations = await database.managers.explanations.get();
        expect(explanations.length, 0);
      },
    );

    test(
      'should cascade delete both bookmarks and explanations when PDF book is deleted',
      () async {
        final now = DateTime.now();

        await database.managers.pdfBooks.create(
          (o) => o(
            id: 'book1',
            title: 'Test Book',
            filePath: '/path/to/book.pdf',
            totalPages: 100,
          ),
        );

        await database.managers.bookmarks.create(
          (o) => o(
            id: 'bookmark1',
            pdfBookId: 'book1',
            pageNumber: 42,
            createdAt: now,
          ),
        );

        await database.managers.explanations.create(
          (o) => o(
            id: 'explanation1',
            pdfBookId: 'book1',
            pageNumber: 10,
            selectedText: 'polymorphism',
            explanation: 'Polymorphism is...',
            sources: '[]',
            createdAt: now,
          ),
        );

        await database.managers.pdfBooks.filter((f) => f.id('book1')).delete();

        final bookmarks = await database.managers.bookmarks.get();
        final explanations = await database.managers.explanations.get();

        expect(bookmarks.length, 0);
        expect(explanations.length, 0);
      },
    );

    test('should not delete bookmarks of other PDF books', () async {
      final now = DateTime.now();

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book 1',
          filePath: '/path/to/book1.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book2',
          title: 'Test Book 2',
          filePath: '/path/to/book2.pdf',
          totalPages: 200,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark1',
          pdfBookId: 'book1',
          pageNumber: 42,
          createdAt: now,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark2',
          pdfBookId: 'book2',
          pageNumber: 84,
          createdAt: now,
        ),
      );

      await database.managers.pdfBooks.filter((f) => f.id('book1')).delete();

      final bookmarks = await database.managers.bookmarks.get();
      expect(bookmarks.length, 1);
      expect(bookmarks.first.pdfBookId, 'book2');
    });
  });

  group('Query Filter Operations', () {
    test('should filter PDF books by title', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Flutter Development',
          filePath: '/path/to/book1.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book2',
          title: 'Dart Programming',
          filePath: '/path/to/book2.pdf',
          totalPages: 200,
        ),
      );

      final books = await database.managers.pdfBooks
          .filter((f) => f.title.contains('Flutter'))
          .get();

      expect(books.length, 1);
      expect(books.first.title, 'Flutter Development');
    });

    test('should filter bookmarks by page number range', () async {
      final now = DateTime.now();

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark1',
          pdfBookId: 'book1',
          pageNumber: 10,
          createdAt: now,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark2',
          pdfBookId: 'book1',
          pageNumber: 50,
          createdAt: now,
        ),
      );

      await database.managers.bookmarks.create(
        (o) => o(
          id: 'bookmark3',
          pdfBookId: 'book1',
          pageNumber: 90,
          createdAt: now,
        ),
      );

      final bookmarks = await database.managers.bookmarks
          .filter((f) => f.pageNumber.isBiggerThan(20))
          .get();

      expect(bookmarks.length, 2);
    });

    test('should filter explanations by selected text', () async {
      final now = DateTime.now();

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );

      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation1',
          pdfBookId: 'book1',
          pageNumber: 10,
          selectedText: 'polymorphism',
          explanation: 'Polymorphism is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      await database.managers.explanations.create(
        (o) => o(
          id: 'explanation2',
          pdfBookId: 'book1',
          pageNumber: 20,
          selectedText: 'inheritance',
          explanation: 'Inheritance is...',
          sources: '[]',
          createdAt: now,
        ),
      );

      final explanations = await database.managers.explanations
          .filter((f) => f.selectedText.contains('poly'))
          .get();

      expect(explanations.length, 1);
      expect(explanations.first.selectedText, 'polymorphism');
    });

    test('should order PDF books by last read date', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Book 1',
          filePath: '/path/to/book1.pdf',
          totalPages: 100,
          lastRead: Value(yesterday),
        ),
      );

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book2',
          title: 'Book 2',
          filePath: '/path/to/book2.pdf',
          totalPages: 200,
          lastRead: Value(now),
        ),
      );

      final books = await database.managers.pdfBooks
          .orderBy((o) => o.lastRead.desc())
          .get();

      expect(books.first.id, 'book2');
      expect(books.last.id, 'book1');
    });

    test('should combine multiple filters', () async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Flutter Development',
          filePath: '/path/to/book1.pdf',
          totalPages: 100,
          isFavorite: const Value(true),
        ),
      );

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book2',
          title: 'Flutter Testing',
          filePath: '/path/to/book2.pdf',
          totalPages: 200,
          isFavorite: const Value(false),
        ),
      );

      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book3',
          title: 'Dart Programming',
          filePath: '/path/to/book3.pdf',
          totalPages: 150,
          isFavorite: const Value(true),
        ),
      );

      final books = await database.managers.pdfBooks
          .filter((f) => f.title.contains('Flutter') & f.isFavorite(true))
          .get();

      expect(books.length, 1);
      expect(books.first.id, 'book1');
    });
  });
}
