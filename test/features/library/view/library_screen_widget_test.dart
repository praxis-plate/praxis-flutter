import 'package:bloc_test/bloc_test.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/features/library/bloc/library_bloc.dart';
import 'package:codium/features/library/view/library_screen.dart';
import 'package:codium/features/library/widgets/pdf_book_card.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class MockLibraryBloc extends MockBloc<LibraryEvent, LibraryState>
    implements LibraryBloc {}

void main() {
  late MockLibraryBloc mockLibraryBloc;

  setUp(() {
    mockLibraryBloc = MockLibraryBloc();
  });

  tearDown(() {
    if (GetIt.I.isRegistered<LibraryBloc>()) {
      GetIt.I.unregister<LibraryBloc>();
    }
  });

  Widget createWidgetUnderTest() {
    GetIt.I.registerFactory<LibraryBloc>(() => mockLibraryBloc);
    return const MaterialApp(
      localizationsDelegates: S.localizationDelegates,
      supportedLocales: S.supportedLocales,
      home: LibraryScreen(),
    );
  }

  group('LibraryScreen Widget Tests', () {
    group('PDF Grid Display', () {
      testWidgets('displays loading indicator when state is loading', (
        tester,
      ) async {
        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([LibraryLoadingState()]),
          initialState: LibraryLoadingState(),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('displays empty state when no PDFs are available', (
        tester,
      ) async {
        const emptyState = LibraryLoadedState(books: [], filteredBooks: []);

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([emptyState]),
          initialState: emptyState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('No PDFs in library'), findsOneWidget);
        expect(find.text('Tap + to import your first PDF'), findsOneWidget);
        expect(find.byIcon(Icons.library_books_outlined), findsOneWidget);
      });

      testWidgets('displays grid of PDF books when books are loaded', (
        tester,
      ) async {
        final books = [
          const PdfBook(
            id: '1',
            title: 'Clean Code',
            author: 'Robert C. Martin',
            filePath: '/path/to/clean_code.pdf',
            totalPages: 464,
            currentPage: 100,
            isFavorite: true,
          ),
          const PdfBook(
            id: '2',
            title: 'Design Patterns',
            author: 'Gang of Four',
            filePath: '/path/to/design_patterns.pdf',
            totalPages: 395,
            currentPage: 50,
            isFavorite: false,
          ),
        ];

        final loadedState = LibraryLoadedState(
          books: books,
          filteredBooks: books,
        );

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(PdfBookCard), findsNWidgets(2));
        expect(find.text('Clean Code'), findsOneWidget);
        expect(find.text('Design Patterns'), findsOneWidget);
        expect(find.text('Robert C. Martin'), findsOneWidget);
        expect(find.text('Gang of Four'), findsOneWidget);
      });

      testWidgets('displays correct progress information for each book', (
        tester,
      ) async {
        final books = [
          const PdfBook(
            id: '1',
            title: 'Test Book',
            filePath: '/path/to/test.pdf',
            totalPages: 200,
            currentPage: 100,
          ),
        ];

        final loadedState = LibraryLoadedState(
          books: books,
          filteredBooks: books,
        );

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('100 / 200 pages'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('displays favorite indicator for favorite books', (
        tester,
      ) async {
        final books = [
          const PdfBook(
            id: '1',
            title: 'Favorite Book',
            filePath: '/path/to/favorite.pdf',
            totalPages: 100,
            isFavorite: true,
          ),
          const PdfBook(
            id: '2',
            title: 'Regular Book',
            filePath: '/path/to/regular.pdf',
            totalPages: 100,
            isFavorite: false,
          ),
        ];

        final loadedState = LibraryLoadedState(
          books: books,
          filteredBooks: books,
        );

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });

      testWidgets('displays error state with retry button on error', (
        tester,
      ) async {
        const errorState = LibraryErrorState(
          errorCode: AppErrorCode.databaseGeneral,
          message: 'Failed to load library',
        );

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([errorState]),
          initialState: errorState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Error loading library'), findsOneWidget);
        expect(find.text('Failed to load library'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('retry button is tappable', (tester) async {
        const errorState = LibraryErrorState(
          errorCode: AppErrorCode.databaseGeneral,
          message: 'Failed to load library',
        );

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([errorState]),
          initialState: errorState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final retryButton = find.text('Retry');
        expect(retryButton, findsOneWidget);

        await tester.tap(retryButton);
        await tester.pump();
      });
    });

    group('Import Button', () {
      testWidgets('displays import button in app bar', (tester) async {
        const loadedState = LibraryLoadedState(books: [], filteredBooks: []);

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add), findsNWidgets(2));
        expect(find.widgetWithIcon(IconButton, Icons.add), findsOneWidget);
      });

      testWidgets('import button is always visible regardless of state', (
        tester,
      ) async {
        const loadedState = LibraryLoadedState(books: [], filteredBooks: []);

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add), findsNWidgets(2));
      });
    });

    group('Search Functionality', () {
      testWidgets('displays search bar', (tester) async {
        const loadedState = LibraryLoadedState(books: [], filteredBooks: []);

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Search by title or author...'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('search bar accepts text input', (tester) async {
        const loadedState = LibraryLoadedState(books: [], filteredBooks: []);

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Clean Code');
        await tester.pump();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller?.text, equals('Clean Code'));
      });

      testWidgets('displays filtered results when searching', (tester) async {
        final allBooks = [
          const PdfBook(
            id: '1',
            title: 'Clean Code',
            filePath: '/path/to/clean_code.pdf',
            totalPages: 464,
          ),
          const PdfBook(
            id: '2',
            title: 'Design Patterns',
            filePath: '/path/to/design_patterns.pdf',
            totalPages: 395,
          ),
        ];

        final filteredBooks = [allBooks[0]];

        final loadedState = LibraryLoadedState(
          books: allBooks,
          filteredBooks: filteredBooks,
          searchQuery: 'Clean',
        );

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(PdfBookCard), findsOneWidget);
        expect(find.text('Clean Code'), findsOneWidget);
        expect(find.text('Design Patterns'), findsNothing);
      });

      testWidgets('search field initially has no clear button', (tester) async {
        const loadedState = LibraryLoadedState(books: [], filteredBooks: []);

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.clear), findsNothing);
      });

      testWidgets('displays "No books found" when search returns no results', (
        tester,
      ) async {
        const loadedState = LibraryLoadedState(
          books: [],
          filteredBooks: [],
          searchQuery: 'nonexistent',
        );

        whenListen(
          mockLibraryBloc,
          Stream<LibraryState>.fromIterable([loadedState]),
          initialState: loadedState,
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('No books found'), findsOneWidget);
        expect(find.byIcon(Icons.search_off), findsOneWidget);
      });
    });
  });
}
