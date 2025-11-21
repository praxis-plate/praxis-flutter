import 'package:bloc_test/bloc_test.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/usecases/save_bookmark_usecase.dart';
import 'package:codium/domain/usecases/update_reading_progress_usecase.dart';
import 'package:codium/domain/usecases/validate_and_open_pdf_usecase.dart';
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
import 'progressive_rendering_property_test.mocks.dart';

void main() {
  group('Property 30: Progressive PDF Rendering', () {
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

    test('For any PDF being loaded with progressive rendering enabled, '
        'adjacent pages should be preloaded', () async {
      final testCases = [
        {'totalPages': 10, 'currentPage': 0},
        {'totalPages': 50, 'currentPage': 25},
        {'totalPages': 100, 'currentPage': 99},
        {'totalPages': 200, 'currentPage': 100},
        {'totalPages': 5, 'currentPage': 2},
      ];

      for (final testCase in testCases) {
        final totalPages = testCase['totalPages'] as int;
        final currentPage = testCase['currentPage'] as int;

        final book = PdfBook(
          id: 'test-$totalPages-$currentPage',
          title: 'Test Book',
          filePath: '/path/to/test.pdf',
          totalPages: totalPages,
          currentPage: currentPage,
        );

        when(
          mockValidateAndOpenPdfUseCase.execute(any),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

        final bloc = PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: const PdfRenderingConfig(
            enableProgressiveRendering: true,
          ),
        );

        bloc.add(OpenPdfEvent(book.id));

        await Future.delayed(const Duration(milliseconds: 100));

        verify(
          mockCacheService.preloadAdjacentPages(currentPage, totalPages),
        ).called(1);

        await bloc.close();
        reset(mockCacheService);
        reset(mockValidateAndOpenPdfUseCase);
      }
    });

    test('For any page change with progressive rendering enabled, '
        'adjacent pages should be preloaded', () async {
      final testCases = [
        {'totalPages': 100, 'oldPage': 10, 'newPage': 11},
        {'totalPages': 50, 'oldPage': 25, 'newPage': 30},
        {'totalPages': 200, 'oldPage': 0, 'newPage': 1},
        {'totalPages': 150, 'oldPage': 149, 'newPage': 148},
      ];

      for (final testCase in testCases) {
        final totalPages = testCase['totalPages'] as int;
        final oldPage = testCase['oldPage'] as int;
        final newPage = testCase['newPage'] as int;

        final book = PdfBook(
          id: 'test-$totalPages',
          title: 'Test Book',
          filePath: '/path/to/test.pdf',
          totalPages: totalPages,
          currentPage: oldPage,
        );

        when(
          mockValidateAndOpenPdfUseCase.execute(any),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));
        when(
          mockUpdateReadingProgressUseCase.execute(
            bookId: anyNamed('bookId'),
            currentPage: anyNamed('currentPage'),
          ),
        ).thenAnswer((_) async {});

        final bloc = PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: const PdfRenderingConfig(
            enableProgressiveRendering: true,
          ),
        );

        bloc.add(OpenPdfEvent(book.id));
        await Future.delayed(const Duration(milliseconds: 100));

        bloc.add(ChangePageEvent(newPage));
        await Future.delayed(const Duration(milliseconds: 100));

        verify(
          mockCacheService.preloadAdjacentPages(newPage, totalPages),
        ).called(1);

        await bloc.close();
        reset(mockCacheService);
        reset(mockValidateAndOpenPdfUseCase);
        reset(mockUpdateReadingProgressUseCase);
      }
    });

    test('For any PDF with progressive rendering disabled, '
        'pages should not be preloaded', () async {
      final book = PdfBook(
        id: 'test-id',
        title: 'Test Book',
        filePath: '/path/to/test.pdf',
        totalPages: 100,
        currentPage: 50,
      );

      when(
        mockValidateAndOpenPdfUseCase.execute(any),
      ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

      final bloc = PdfReaderBloc(
        validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
        updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
        cacheService: mockCacheService,
        renderingConfig: const PdfRenderingConfig(
          enableProgressiveRendering: false,
        ),
      );

      bloc.add(const OpenPdfEvent('test-id'));
      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(mockCacheService.preloadAdjacentPages(any, any));

      await bloc.close();
    });
  });
}
