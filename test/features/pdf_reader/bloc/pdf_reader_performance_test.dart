import 'package:bloc_test/bloc_test.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/usecases/get_pdf_book_by_id_usecase.dart';
import 'package:codium/domain/usecases/save_bookmark_usecase.dart';
import 'package:codium/domain/usecases/update_reading_progress_usecase.dart';
import 'package:codium/features/pdf_reader/bloc/pdf_reader_bloc.dart';
import 'package:codium/features/pdf_reader/domain/pdf_cache_service.dart';
import 'package:codium/features/pdf_reader/domain/pdf_rendering_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  GetPdfBookByIdUseCase,
  UpdateReadingProgressUseCase,
  SaveBookmarkUseCase,
  PdfCacheService,
])
import 'pdf_reader_performance_test.mocks.dart';

void main() {
  group('PdfReaderBloc Performance Features', () {
    late MockGetPdfBookByIdUseCase mockGetPdfBookByIdUseCase;
    late MockUpdateReadingProgressUseCase mockUpdateReadingProgressUseCase;
    late MockSaveBookmarkUseCase mockSaveBookmarkUseCase;
    late MockPdfCacheService mockCacheService;

    setUp(() {
      mockGetPdfBookByIdUseCase = MockGetPdfBookByIdUseCase();
      mockUpdateReadingProgressUseCase = MockUpdateReadingProgressUseCase();
      mockSaveBookmarkUseCase = MockSaveBookmarkUseCase();
      mockCacheService = MockPdfCacheService();
    });

    final testBook = PdfBook(
      id: 'test-id',
      title: 'Test Book',
      filePath: '/path/to/test.pdf',
      totalPages: 150,
      currentPage: 5,
    );

    blocTest<PdfReaderBloc, PdfReaderState>(
      'should enable lazy loading for large PDFs',
      build: () {
        when(
          mockGetPdfBookByIdUseCase.execute(any),
        ).thenAnswer((_) async => testBook);
        return PdfReaderBloc(
          getPdfBookByIdUseCase: mockGetPdfBookByIdUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: const PdfRenderingConfig(lazyLoadingThreshold: 100),
        );
      },
      act: (bloc) => bloc.add(const OpenPdfEvent('test-id')),
      expect: () => [
        PdfReaderLoadingState(),
        isA<PdfReaderLoadedState>()
            .having((s) => s.useLazyLoading, 'useLazyLoading', true)
            .having((s) => s.book, 'book', testBook),
      ],
    );

    blocTest<PdfReaderBloc, PdfReaderState>(
      'should not enable lazy loading for small PDFs',
      build: () {
        final smallBook = testBook.copyWith(totalPages: 50);
        when(
          mockGetPdfBookByIdUseCase.execute(any),
        ).thenAnswer((_) async => smallBook);
        return PdfReaderBloc(
          getPdfBookByIdUseCase: mockGetPdfBookByIdUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: const PdfRenderingConfig(lazyLoadingThreshold: 100),
        );
      },
      act: (bloc) => bloc.add(const OpenPdfEvent('test-id')),
      expect: () => [
        PdfReaderLoadingState(),
        isA<PdfReaderLoadedState>().having(
          (s) => s.useLazyLoading,
          'useLazyLoading',
          false,
        ),
      ],
    );

    blocTest<PdfReaderBloc, PdfReaderState>(
      'should clear cache when opening PDF',
      build: () {
        when(
          mockGetPdfBookByIdUseCase.execute(any),
        ).thenAnswer((_) async => testBook);
        return PdfReaderBloc(
          getPdfBookByIdUseCase: mockGetPdfBookByIdUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
        );
      },
      act: (bloc) => bloc.add(const OpenPdfEvent('test-id')),
      verify: (_) {
        verify(mockCacheService.clearCache()).called(greaterThanOrEqualTo(1));
      },
    );

    blocTest<PdfReaderBloc, PdfReaderState>(
      'should preload adjacent pages when progressive rendering is enabled',
      build: () {
        when(
          mockGetPdfBookByIdUseCase.execute(any),
        ).thenAnswer((_) async => testBook);
        return PdfReaderBloc(
          getPdfBookByIdUseCase: mockGetPdfBookByIdUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: const PdfRenderingConfig(
            enableProgressiveRendering: true,
          ),
        );
      },
      act: (bloc) => bloc.add(const OpenPdfEvent('test-id')),
      verify: (_) {
        verify(mockCacheService.preloadAdjacentPages(5, 150)).called(1);
      },
    );

    blocTest<PdfReaderBloc, PdfReaderState>(
      'should save scroll position',
      build: () {
        when(
          mockGetPdfBookByIdUseCase.execute(any),
        ).thenAnswer((_) async => testBook);
        return PdfReaderBloc(
          getPdfBookByIdUseCase: mockGetPdfBookByIdUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
        );
      },
      seed: () => PdfReaderLoadedState(book: testBook, currentPage: 5),
      act: (bloc) => bloc.add(const SaveScrollPositionEvent(123.45)),
      expect: () => [
        isA<PdfReaderLoadedState>().having(
          (s) => s.scrollPosition,
          'scrollPosition',
          123.45,
        ),
      ],
    );

    blocTest<PdfReaderBloc, PdfReaderState>(
      'should preload adjacent pages on page change',
      build: () {
        when(
          mockGetPdfBookByIdUseCase.execute(any),
        ).thenAnswer((_) async => testBook);
        when(
          mockUpdateReadingProgressUseCase.execute(
            bookId: anyNamed('bookId'),
            currentPage: anyNamed('currentPage'),
          ),
        ).thenAnswer((_) async {});
        return PdfReaderBloc(
          getPdfBookByIdUseCase: mockGetPdfBookByIdUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: const PdfRenderingConfig(
            enableProgressiveRendering: true,
          ),
        );
      },
      seed: () => PdfReaderLoadedState(book: testBook, currentPage: 5),
      act: (bloc) => bloc.add(const ChangePageEvent(10)),
      verify: (_) {
        verify(mockCacheService.preloadAdjacentPages(10, 150)).called(1);
      },
    );

    test('should clear cache on close', () async {
      final bloc = PdfReaderBloc(
        getPdfBookByIdUseCase: mockGetPdfBookByIdUseCase,
        updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
        cacheService: mockCacheService,
      );

      await bloc.close();

      verify(mockCacheService.clearCache()).called(1);
    });
  });
}
