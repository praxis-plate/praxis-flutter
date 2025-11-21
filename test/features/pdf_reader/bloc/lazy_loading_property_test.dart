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
import 'lazy_loading_property_test.mocks.dart';

void main() {
  group('Property 31: Lazy Loading for Large PDFs', () {
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

    test('For any PDF with more than threshold pages, '
        'lazy loading should be enabled', () async {
      final testCases = [
        {'totalPages': 101, 'threshold': 100, 'shouldEnable': true},
        {'totalPages': 150, 'threshold': 100, 'shouldEnable': true},
        {'totalPages': 200, 'threshold': 100, 'shouldEnable': true},
        {'totalPages': 500, 'threshold': 100, 'shouldEnable': true},
        {'totalPages': 100, 'threshold': 100, 'shouldEnable': false},
        {'totalPages': 99, 'threshold': 100, 'shouldEnable': false},
        {'totalPages': 50, 'threshold': 100, 'shouldEnable': false},
        {'totalPages': 10, 'threshold': 100, 'shouldEnable': false},
        {'totalPages': 51, 'threshold': 50, 'shouldEnable': true},
        {'totalPages': 50, 'threshold': 50, 'shouldEnable': false},
      ];

      for (final testCase in testCases) {
        final totalPages = testCase['totalPages'] as int;
        final threshold = testCase['threshold'] as int;
        final shouldEnable = testCase['shouldEnable'] as bool;

        final book = PdfBook(
          id: 'test-$totalPages-$threshold',
          title: 'Test Book',
          filePath: '/path/to/test.pdf',
          totalPages: totalPages,
          currentPage: 0,
        );

        when(
          mockValidateAndOpenPdfUseCase.execute(any),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

        final bloc = PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: PdfRenderingConfig(lazyLoadingThreshold: threshold),
        );

        bloc.add(OpenPdfEvent(book.id));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<PdfReaderLoadingState>(),
            isA<PdfReaderLoadedState>().having(
              (s) => s.useLazyLoading,
              'useLazyLoading',
              shouldEnable,
            ),
          ]),
        );

        await bloc.close();
        reset(mockValidateAndOpenPdfUseCase);
      }
    });

    test(
      'For any PDF with lazy loading disabled in config, '
      'lazy loading should not be enabled regardless of page count',
      () async {
        final testCases = [
          {'totalPages': 101},
          {'totalPages': 200},
          {'totalPages': 500},
          {'totalPages': 1000},
        ];

        for (final testCase in testCases) {
          final totalPages = testCase['totalPages'] as int;

          final book = PdfBook(
            id: 'test-$totalPages',
            title: 'Test Book',
            filePath: '/path/to/test.pdf',
            totalPages: totalPages,
            currentPage: 0,
          );

          when(
            mockValidateAndOpenPdfUseCase.execute(any),
          ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

          final bloc = PdfReaderBloc(
            validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
            updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
            saveBookmarkUseCase: mockSaveBookmarkUseCase,
            cacheService: mockCacheService,
            renderingConfig: const PdfRenderingConfig(enableLazyLoading: false),
          );

          bloc.add(OpenPdfEvent(book.id));

          await expectLater(
            bloc.stream,
            emitsInOrder([
              isA<PdfReaderLoadingState>(),
              isA<PdfReaderLoadedState>().having(
                (s) => s.useLazyLoading,
                'useLazyLoading',
                false,
              ),
            ]),
          );

          await bloc.close();
          reset(mockValidateAndOpenPdfUseCase);
        }
      },
    );

    test('For any PDF exactly at threshold, '
        'lazy loading should not be enabled', () async {
      final testCases = [
        {'threshold': 50},
        {'threshold': 100},
        {'threshold': 200},
      ];

      for (final testCase in testCases) {
        final threshold = testCase['threshold'] as int;

        final book = PdfBook(
          id: 'test-$threshold',
          title: 'Test Book',
          filePath: '/path/to/test.pdf',
          totalPages: threshold,
          currentPage: 0,
        );

        when(
          mockValidateAndOpenPdfUseCase.execute(any),
        ).thenAnswer((_) async => ValidatedPdfResult.success(book: book));

        final bloc = PdfReaderBloc(
          validateAndOpenPdfUseCase: mockValidateAndOpenPdfUseCase,
          updateReadingProgressUseCase: mockUpdateReadingProgressUseCase,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
          cacheService: mockCacheService,
          renderingConfig: PdfRenderingConfig(lazyLoadingThreshold: threshold),
        );

        bloc.add(OpenPdfEvent(book.id));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<PdfReaderLoadingState>(),
            isA<PdfReaderLoadedState>().having(
              (s) => s.useLazyLoading,
              'useLazyLoading',
              false,
            ),
          ]),
        );

        await bloc.close();
        reset(mockValidateAndOpenPdfUseCase);
      }
    });
  });
}
