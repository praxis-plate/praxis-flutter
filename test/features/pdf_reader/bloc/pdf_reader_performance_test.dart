import 'package:bloc_test/bloc_test.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/pdf_reader/bloc/pdf_reader_bloc.dart';
import 'package:codium/features/pdf_reader/domain/pdf_cache_service.dart';
import 'package:codium/features/pdf_reader/domain/pdf_rendering_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  ValidateAndOpenPdfUseCase,
  UpdateReadingProgressUseCase,
  SaveBookmarkUseCase,
  PdfCacheService,
])
import 'pdf_reader_performance_test.mocks.dart';

void main() {
  group('PdfReaderBloc Performance Features', () {
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

    const testBook = PdfBook(
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
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: testBook));
        return PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
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
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: smallBook));
        return PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
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
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: testBook));
        return PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
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
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: testBook));
        return PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
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
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: testBook));
        return PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
        );
      },
      seed: () => const PdfReaderLoadedState(book: testBook, currentPage: 5),
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
          mockValidateAndOpenPdfUseCase(argThat(anything)),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: testBook));
        when(
          mockUpdateReadingProgressUseCase(
            bookId: argThat(anything, named: 'bookId'),
            currentPage: argThat(anything, named: 'currentPage'),
          ),
        ).thenAnswer((_) async {});
        return PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: const PdfRenderingConfig(
            enableProgressiveRendering: true,
          ),
        );
      },
      seed: () => const PdfReaderLoadedState(book: testBook, currentPage: 5),
      act: (bloc) => bloc.add(const ChangePageEvent(10)),
      verify: (_) {
        verify(mockCacheService.preloadAdjacentPages(10, 150)).called(1);
      },
    );

    test('should clear cache on close', () async {
      final bloc = PdfReaderBloc(
        validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
        updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
        cacheService: mockCacheService,
      );

      await bloc.close();

      verify(mockCacheService.clearCache()).called(1);
    });
  });
}
