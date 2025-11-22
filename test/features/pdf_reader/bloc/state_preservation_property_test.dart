import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/pdf_reader/bloc/pdf_reader_bloc.dart';
import 'package:codium/features/pdf_reader/domain/pdf_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  ValidateAndOpenPdfUseCase,
  UpdateReadingProgressUseCase,
  SaveBookmarkUseCase,
  PdfCacheService,
])
import 'state_preservation_property_test.mocks.dart';

void main() {
  group('Property 32: PDF State Preservation', () {
    late MockValidateAndOpenPdfUseCase mockValidateAndOpenPdfUseCase;
    late MockUpdateReadingProgressUseCase mockUpdateReadingProgressUseCase;
    late MockSaveBookmarkUseCase mockSaveBookmarkUseCase;
    late MockPdfCacheService mockCacheService;

    setUp(() {
      mockValidateAndOpenPdfUseCase = MockValidateAndOpenPdfUseCase();
      mockUpdateReadingProgressUseCase = MockUpdateReadingProgressUseCase();
      mockSaveBookmarkUseCase = MockSaveBookmarkUseCase();
      mockCacheService = MockPdfCacheService();
    });

    test('For any scroll position saved, '
        'the state should preserve that scroll position', () async {
      final testCases = [
        {'scrollPosition': 0.0},
        {'scrollPosition': 100.5},
        {'scrollPosition': 250.75},
        {'scrollPosition': 500.0},
        {'scrollPosition': 1000.25},
        {'scrollPosition': 9999.99},
      ];

      for (final testCase in testCases) {
        final scrollPosition = testCase['scrollPosition'] as double;

        const book = PdfBook(
          id: 'test-id',
          title: 'Test Book',
          filePath: '/path/to/test.pdf',
          totalPages: 100,
          currentPage: 50,
        );

        when(
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

        final bloc = PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
        );

        bloc.add(const OpenPdfEvent('test-id'));
        await Future.delayed(const Duration(milliseconds: 100));

        bloc.add(SaveScrollPositionEvent(scrollPosition));

        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<PdfReaderLoadedState>().having(
              (s) => s.scrollPosition,
              'scrollPosition',
              scrollPosition,
            ),
          ),
        );

        await bloc.close();
        reset(mockValidateAndOpenPdfUseCase);
      }
    });

    test('For any PDF switch, '
        'the previous scroll position should be preserved in state', () async {
      const book1 = PdfBook(
        id: 'book-1',
        title: 'Book 1',
        filePath: '/path/to/book1.pdf',
        totalPages: 100,
        currentPage: 10,
      );

      const book2 = PdfBook(
        id: 'book-2',
        title: 'Book 2',
        filePath: '/path/to/book2.pdf',
        totalPages: 200,
        currentPage: 50,
      );

      when(
        mockValidateAndOpenPdfUseCase('book-1'),
      ).thenAnswer((_) async => ValidatedPdfResult.success(book: book1));
      when(
        mockValidateAndOpenPdfUseCase('book-2'),
      ).thenAnswer((_) async => ValidatedPdfResult.success(book: book2));

      final bloc = PdfReaderBloc(
        validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
        updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
        cacheService: mockCacheService,
      );

      bloc.add(const OpenPdfEvent('book-1'));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const SaveScrollPositionEvent(123.45));
      await Future.delayed(const Duration(milliseconds: 100));

      final stateBeforeSwitch = bloc.state as PdfReaderLoadedState;
      expect(stateBeforeSwitch.scrollPosition, 123.45);
      expect(stateBeforeSwitch.book.id, 'book-1');

      bloc.add(const OpenPdfEvent('book-2'));
      await Future.delayed(const Duration(milliseconds: 100));

      final stateAfterSwitch = bloc.state as PdfReaderLoadedState;
      expect(stateAfterSwitch.book.id, 'book-2');

      await bloc.close();
    });

    test('For any PDF reopened with saved scroll position, '
        'the scroll position should be restored', () async {
      final testCases = [
        {'scrollPosition': 50.0},
        {'scrollPosition': 150.5},
        {'scrollPosition': 300.75},
      ];

      for (final testCase in testCases) {
        final scrollPosition = testCase['scrollPosition'] as double;

        const book = PdfBook(
          id: 'test-id',
          title: 'Test Book',
          filePath: '/path/to/test.pdf',
          totalPages: 100,
          currentPage: 50,
        );

        when(
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

        final bloc = PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
        );

        bloc.add(const OpenPdfEvent('test-id'));
        await Future.delayed(const Duration(milliseconds: 100));

        bloc.add(SaveScrollPositionEvent(scrollPosition));
        await Future.delayed(const Duration(milliseconds: 100));

        final savedState = bloc.state as PdfReaderLoadedState;
        expect(savedState.scrollPosition, scrollPosition);

        await bloc.close();
        reset(mockValidateAndOpenPdfUseCase);
      }
    });

    test('For any multiple scroll position updates, '
        'only the latest position should be preserved', () async {
      const book = PdfBook(
        id: 'test-id',
        title: 'Test Book',
        filePath: '/path/to/test.pdf',
        totalPages: 100,
        currentPage: 50,
      );

      when(
        mockValidateAndOpenPdfUseCase(argThat(anything)),
      ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

      final bloc = PdfReaderBloc(
        validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
        updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
        cacheService: mockCacheService,
      );

      bloc.add(const OpenPdfEvent('test-id'));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const SaveScrollPositionEvent(100));
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const SaveScrollPositionEvent(200));
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const SaveScrollPositionEvent(300));
      await Future.delayed(const Duration(milliseconds: 50));

      final finalState = bloc.state as PdfReaderLoadedState;
      expect(finalState.scrollPosition, 300);

      await bloc.close();
    });

    test('For any PDF with null scroll position initially, '
        'scroll position should be null until explicitly set', () async {
      const book = PdfBook(
        id: 'test-id',
        title: 'Test Book',
        filePath: '/path/to/test.pdf',
        totalPages: 100,
        currentPage: 50,
      );

      when(
        mockValidateAndOpenPdfUseCase(argThat(anything)),
      ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

      final bloc = PdfReaderBloc(
        validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
        updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
        cacheService: mockCacheService,
      );

      bloc.add(const OpenPdfEvent('test-id'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PdfReaderLoadingState>(),
          isA<PdfReaderLoadedState>().having(
            (s) => s.scrollPosition,
            'scrollPosition',
            null,
          ),
        ]),
      );

      await bloc.close();
    });
  });
}
