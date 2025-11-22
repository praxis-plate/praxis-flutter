import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/library/bloc/library_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'library_bloc_test.mocks.dart';

@GenerateMocks([
  GetPdfListUseCase,
  ImportPdfUseCase,
  DeletePdfUseCase,
  ToggleFavoritePdfUseCase,
  Talker,
])
void main() {
  late LibraryBloc bloc;
  late MockGetPdfListUseCase mockGetPdfListUseCase;
  late MockImportPdfUseCase mockImportPdfUseCase;
  late MockDeletePdfUseCase mockDeletePdfUseCase;
  late MockToggleFavoritePdfUseCase mockToggleFavoritePdfUseCase;
  late MockTalker mockTalker;

  setUp(() {
    mockGetPdfListUseCase = MockGetPdfListUseCase();
    mockImportPdfUseCase = MockImportPdfUseCase();
    mockDeletePdfUseCase = MockDeletePdfUseCase();
    mockToggleFavoritePdfUseCase = MockToggleFavoritePdfUseCase();
    mockTalker = MockTalker();

    // Register Talker mock in GetIt
    if (!GetIt.I.isRegistered<Talker>()) {
      GetIt.I.registerSingleton<Talker>(mockTalker);
    }

    bloc = LibraryBloc(
      getPdfListUseCase: mockGetPdfListUseCase,
      importPdfUseCase: mockImportPdfUseCase,
      deletePdfUseCase: mockDeletePdfUseCase,
      toggleFavoritePdfUseCase: mockToggleFavoritePdfUseCase,
    );
  });

  tearDown(() {
    bloc.close();
    if (GetIt.I.isRegistered<Talker>()) {
      GetIt.I.unregister<Talker>();
    }
  });

  group('LibraryBloc - Property Tests', () {
    test('Feature: codium-ai-enhancement, Property 7: PDF Library Display - '
        'For any PDF in the database, the library view should display its '
        'cover, title, and reading progress', () async {
      final testCases = _generatePropertyTestCases(100);

      for (final books in testCases) {
        when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

        bloc.add(LoadLibraryEvent());

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<LibraryLoadingState>(),
            isA<LibraryLoadedState>()
                .having((state) => state.books, 'books', equals(books))
                .having(
                  (state) => state.filteredBooks,
                  'filteredBooks',
                  equals(books),
                ),
          ]),
        );

        final currentState = bloc.state as LibraryLoadedState;

        expect(currentState.books.length, equals(books.length));
        expect(currentState.filteredBooks.length, equals(books.length));

        for (var i = 0; i < books.length; i++) {
          final book = books[i];
          final displayedBook = currentState.books[i];

          expect(displayedBook.id, equals(book.id));
          expect(displayedBook.title, equals(book.title));
          expect(displayedBook.author, equals(book.author));
          expect(displayedBook.totalPages, equals(book.totalPages));
          expect(displayedBook.currentPage, equals(book.currentPage));
          expect(displayedBook.isFavorite, equals(book.isFavorite));
        }

        reset(mockGetPdfListUseCase);
      }
    });

    test('Feature: codium-ai-enhancement, Property 10: Library Search Filter - '
        'For any search query in the library, the results should only include '
        'PDFs where the title, author, or tags match the query', () async {
      final testCases = _generateSearchPropertyTestCases(100);

      for (final testCase in testCases) {
        final books = testCase['books'] as List<PdfBook>;
        final query = testCase['query'] as String;

        when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

        bloc.add(LoadLibraryEvent());
        await bloc.stream.first;
        await bloc.stream.first;

        bloc.add(SearchLibraryEvent(query));

        await expectLater(bloc.stream, emits(isA<LibraryLoadedState>()));

        final currentState = bloc.state as LibraryLoadedState;
        final filteredBooks = currentState.filteredBooks;
        final queryLower = query.toLowerCase();

        for (final book in filteredBooks) {
          final titleMatch = book.title.toLowerCase().contains(queryLower);
          final authorMatch =
              book.author?.toLowerCase().contains(queryLower) ?? false;

          expect(
            titleMatch || authorMatch,
            isTrue,
            reason:
                'Book "${book.title}" by "${book.author}" should match query "$query"',
          );
        }

        for (final book in books) {
          final titleMatch = book.title.toLowerCase().contains(queryLower);
          final authorMatch =
              book.author?.toLowerCase().contains(queryLower) ?? false;
          final shouldBeIncluded = titleMatch || authorMatch;
          final isIncluded = filteredBooks.any((b) => b.id == book.id);

          expect(
            isIncluded,
            equals(shouldBeIncluded),
            reason: shouldBeIncluded
                ? 'Book "${book.title}" by "${book.author}" should be included for query "$query"'
                : 'Book "${book.title}" by "${book.author}" should not be included for query "$query"',
          );
        }

        reset(mockGetPdfListUseCase);
      }
    });
  });

  group('LibraryBloc - Unit Tests', () {
    test(
      'should emit loading then loaded state when LoadLibraryEvent is added',
      () async {
        final books = [
          const PdfBook(
            id: '1',
            title: 'Test Book',
            filePath: '/path/to/book.pdf',
            totalPages: 100,
            currentPage: 50,
          ),
        ];

        when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

        bloc.add(LoadLibraryEvent());

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<LibraryLoadingState>(),
            isA<LibraryLoadedState>()
                .having((state) => state.books, 'books', equals(books))
                .having(
                  (state) => state.filteredBooks,
                  'filteredBooks',
                  equals(books),
                ),
          ]),
        );
      },
    );

    test('should emit error state when LoadLibraryEvent fails', () async {
      when(mockGetPdfListUseCase()).thenThrow(Exception('Database error'));

      bloc.add(LoadLibraryEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<LibraryLoadingState>(),
          isA<LibraryErrorState>().having(
            (state) => state.errorCode,
            'errorCode',
            AppErrorCode.unknown,
          ),
        ]),
      );
    });

    test(
      'should filter books by title when SearchLibraryEvent is added',
      () async {
        final books = [
          const PdfBook(
            id: '1',
            title: 'Dart Programming',
            filePath: '/path/to/dart.pdf',
            totalPages: 100,
          ),
          const PdfBook(
            id: '2',
            title: 'Flutter Development',
            filePath: '/path/to/flutter.pdf',
            totalPages: 200,
          ),
        ];

        when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

        bloc.add(LoadLibraryEvent());
        await bloc.stream.first;
        await bloc.stream.first;

        bloc.add(const SearchLibraryEvent('Dart'));

        await expectLater(
          bloc.stream,
          emits(
            isA<LibraryLoadedState>()
                .having(
                  (state) => state.filteredBooks.length,
                  'filtered count',
                  1,
                )
                .having(
                  (state) => state.filteredBooks.first.title,
                  'title',
                  'Dart Programming',
                ),
          ),
        );
      },
    );

    test(
      'should filter books by author when SearchLibraryEvent is added',
      () async {
        final books = [
          const PdfBook(
            id: '1',
            title: 'Book One',
            author: 'John Doe',
            filePath: '/path/to/book1.pdf',
            totalPages: 100,
          ),
          const PdfBook(
            id: '2',
            title: 'Book Two',
            author: 'Jane Smith',
            filePath: '/path/to/book2.pdf',
            totalPages: 200,
          ),
        ];

        when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

        bloc.add(LoadLibraryEvent());
        await bloc.stream.first;
        await bloc.stream.first;

        bloc.add(const SearchLibraryEvent('Jane'));

        await expectLater(
          bloc.stream,
          emits(
            isA<LibraryLoadedState>()
                .having(
                  (state) => state.filteredBooks.length,
                  'filtered count',
                  1,
                )
                .having(
                  (state) => state.filteredBooks.first.author,
                  'author',
                  'Jane Smith',
                ),
          ),
        );
      },
    );

    test('should show all books when search query is empty', () async {
      final books = [
        const PdfBook(
          id: '1',
          title: 'Book One',
          filePath: '/path/to/book1.pdf',
          totalPages: 100,
        ),
        const PdfBook(
          id: '2',
          title: 'Book Two',
          filePath: '/path/to/book2.pdf',
          totalPages: 200,
        ),
      ];

      when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

      bloc.add(LoadLibraryEvent());
      await bloc.stream.first;
      await bloc.stream.first;

      bloc.add(const SearchLibraryEvent('Book'));
      await bloc.stream.first;

      bloc.add(const SearchLibraryEvent(''));

      await expectLater(
        bloc.stream,
        emits(
          isA<LibraryLoadedState>().having(
            (state) => state.filteredBooks.length,
            'filtered count',
            2,
          ),
        ),
      );
    });

    test('should reload library after ImportPdfEvent', () async {
      final books = [
        const PdfBook(
          id: '1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      ];

      when(mockImportPdfUseCase(argThat(anything))).thenAnswer((_) async => {});
      when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

      bloc.add(const ImportPdfEvent('/path/to/new.pdf'));

      await expectLater(
        bloc.stream,
        emitsInOrder([isA<LibraryLoadingState>(), isA<LibraryLoadedState>()]),
      );

      verify(mockImportPdfUseCase('/path/to/new.pdf')).called(1);
      verify(mockGetPdfListUseCase()).called(1);
    });

    test('should emit error state when ImportPdfEvent fails', () async {
      when(mockImportPdfUseCase(argThat(anything))).thenThrow(Exception('Import failed'));

      bloc.add(const ImportPdfEvent('/path/to/new.pdf'));

      await expectLater(
        bloc.stream,
        emits(
          isA<LibraryErrorState>().having(
            (state) => state.errorCode,
            'errorCode',
            AppErrorCode.unknown,
          ),
        ),
      );
    });

    test('should reload library after DeletePdfEvent', () async {
      final books = [
        const PdfBook(
          id: '2',
          title: 'Remaining Book',
          filePath: '/path/to/book2.pdf',
          totalPages: 100,
        ),
      ];

      when(mockDeletePdfUseCase(any)).thenAnswer((_) async => {});
      when(mockGetPdfListUseCase()).thenAnswer((_) async => books);

      bloc.add(const DeletePdfEvent('1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([isA<LibraryLoadingState>(), isA<LibraryLoadedState>()]),
      );

      verify(mockDeletePdfUseCase('1')).called(1);
      verify(mockGetPdfListUseCase()).called(1);
    });

    test('should emit error state when DeletePdfEvent fails', () async {
      when(mockDeletePdfUseCase(any)).thenThrow(Exception('Delete failed'));

      bloc.add(const DeletePdfEvent('1'));

      await expectLater(
        bloc.stream,
        emits(
          isA<LibraryErrorState>().having(
            (state) => state.errorCode,
            'errorCode',
            AppErrorCode.unknown,
          ),
        ),
      );
    });
  });
}

List<List<PdfBook>> _generatePropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <List<PdfBook>>[];

  final sampleTitles = [
    'Clean Code',
    'Design Patterns',
    'Refactoring',
    'The Pragmatic Programmer',
    'Code Complete',
    'Introduction to Algorithms',
    'Structure and Interpretation of Computer Programs',
    'The Art of Computer Programming',
    'Compilers: Principles, Techniques, and Tools',
    'Operating System Concepts',
    'Database System Concepts',
    'Computer Networks',
    'Artificial Intelligence: A Modern Approach',
    'Deep Learning',
    'Machine Learning',
    'Python Crash Course',
    'JavaScript: The Good Parts',
    'Eloquent JavaScript',
    'You Don\'t Know JS',
    'Learning React',
    'Flutter in Action',
    'Dart Programming',
    'Effective Java',
    'Head First Design Patterns',
    'Domain-Driven Design',
  ];

  final sampleAuthors = [
    'Robert C. Martin',
    'Gang of Four',
    'Martin Fowler',
    'Andrew Hunt',
    'Steve McConnell',
    'Thomas H. Cormen',
    'Harold Abelson',
    'Donald Knuth',
    'Alfred V. Aho',
    'Abraham Silberschatz',
    'Henry F. Korth',
    'Andrew S. Tanenbaum',
    'Stuart Russell',
    'Ian Goodfellow',
    'Tom Mitchell',
    'Eric Matthes',
    'Douglas Crockford',
    'Marijn Haverbeke',
    'Kyle Simpson',
    'Alex Banks',
    'Eric Windmill',
    'Janice Collins',
    'Joshua Bloch',
    'Eric Freeman',
    'Eric Evans',
  ];

  for (var i = 0; i < count; i++) {
    final bookCount = (random + i * 3) % 10 + 1;
    final books = <PdfBook>[];

    for (var j = 0; j < bookCount; j++) {
      final titleIndex = (random + i * 7 + j * 11) % sampleTitles.length;
      final authorIndex = (random + i * 13 + j * 17) % sampleAuthors.length;
      final totalPages = ((random + i * 19 + j * 23) % 500) + 50;
      final currentPage = ((random + i * 29 + j * 31) % totalPages);
      final isFavorite = ((random + i * 37 + j * 41) % 2) == 0;

      books.add(
        PdfBook(
          id: 'book_${i}_$j',
          title: sampleTitles[titleIndex],
          author: sampleAuthors[authorIndex],
          filePath: '/path/to/book_${i}_$j.pdf',
          totalPages: totalPages,
          currentPage: currentPage,
          isFavorite: isFavorite,
        ),
      );
    }

    cases.add(books);
  }

  return cases;
}

List<Map<String, dynamic>> _generateSearchPropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <Map<String, dynamic>>[];

  final sampleTitles = [
    'Clean Code',
    'Design Patterns',
    'Refactoring',
    'The Pragmatic Programmer',
    'Code Complete',
    'Introduction to Algorithms',
    'Structure and Interpretation of Computer Programs',
    'The Art of Computer Programming',
    'Compilers: Principles, Techniques, and Tools',
    'Operating System Concepts',
    'Database System Concepts',
    'Computer Networks',
    'Artificial Intelligence: A Modern Approach',
    'Deep Learning',
    'Machine Learning',
    'Python Crash Course',
    'JavaScript: The Good Parts',
    'Eloquent JavaScript',
    'You Don\'t Know JS',
    'Learning React',
    'Flutter in Action',
    'Dart Programming',
    'Effective Java',
    'Head First Design Patterns',
    'Domain-Driven Design',
  ];

  final sampleAuthors = [
    'Robert C. Martin',
    'Gang of Four',
    'Martin Fowler',
    'Andrew Hunt',
    'Steve McConnell',
    'Thomas H. Cormen',
    'Harold Abelson',
    'Donald Knuth',
    'Alfred V. Aho',
    'Abraham Silberschatz',
    'Henry F. Korth',
    'Andrew S. Tanenbaum',
    'Stuart Russell',
    'Ian Goodfellow',
    'Tom Mitchell',
    'Eric Matthes',
    'Douglas Crockford',
    'Marijn Haverbeke',
    'Kyle Simpson',
    'Alex Banks',
    'Eric Windmill',
    'Janice Collins',
    'Joshua Bloch',
    'Eric Freeman',
    'Eric Evans',
  ];

  final searchQueries = [
    'Code',
    'Design',
    'Programming',
    'Java',
    'Python',
    'JavaScript',
    'Flutter',
    'Dart',
    'Martin',
    'Robert',
    'Donald',
    'Algorithm',
    'Computer',
    'Learning',
    'Patterns',
    'System',
    'Network',
    'Intelligence',
    'Machine',
    'Deep',
    'clean',
    'DESIGN',
    'programming',
    'art',
    'introduction',
  ];

  for (var i = 0; i < count; i++) {
    final bookCount = (random + i * 3) % 10 + 1;
    final books = <PdfBook>[];

    for (var j = 0; j < bookCount; j++) {
      final titleIndex = (random + i * 7 + j * 11) % sampleTitles.length;
      final authorIndex = (random + i * 13 + j * 17) % sampleAuthors.length;
      final totalPages = ((random + i * 19 + j * 23) % 500) + 50;
      final currentPage = ((random + i * 29 + j * 31) % totalPages);
      final isFavorite = ((random + i * 37 + j * 41) % 2) == 0;

      books.add(
        PdfBook(
          id: 'book_${i}_$j',
          title: sampleTitles[titleIndex],
          author: sampleAuthors[authorIndex],
          filePath: '/path/to/book_${i}_$j.pdf',
          totalPages: totalPages,
          currentPage: currentPage,
          isFavorite: isFavorite,
        ),
      );
    }

    final queryIndex = (random + i * 43) % searchQueries.length;
    final query = searchQueries[queryIndex];

    cases.add({'books': books, 'query': query});
  }

  return cases;
}
