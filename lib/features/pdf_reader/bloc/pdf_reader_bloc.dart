import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/exceptions/app_exception.dart';
import 'package:codium/core/utils/pdf_validator.dart';
import 'package:codium/core/utils/retry_logic.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/models/pdf_reader/bookmark.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/pdf_reader/domain/pdf_cache_service.dart';
import 'package:codium/features/pdf_reader/domain/pdf_rendering_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

part 'pdf_reader_event.dart';
part 'pdf_reader_state.dart';

class PdfReaderBloc extends Bloc<PdfReaderEvent, PdfReaderState> {
  final ValidateAndOpenPdfUseCase _validateAndOpenPdfUseCase;
  final UpdateReadingProgressUseCase _updateReadingProgressUseCase;
  final SaveBookmarkUseCase _saveBookmarkUseCase;
  final PdfCacheService _cacheService;
  final PdfRenderingConfig _renderingConfig;

  PdfReaderBloc({
    required ValidateAndOpenPdfUseCase validateAndOpenPdfUseCase,
    required UpdateReadingProgressUseCase updateReadingProgressUseCase,
    required SaveBookmarkUseCase saveBookmarkUseCase,
    PdfCacheService? cacheService,
    PdfRenderingConfig? renderingConfig,
  }) : _validateAndOpenPdfUseCase = validateAndOpenPdfUseCase,
       _updateReadingProgressUseCase = updateReadingProgressUseCase,
       _saveBookmarkUseCase = saveBookmarkUseCase,
       _cacheService = cacheService ?? PdfCacheService(),
       _renderingConfig = renderingConfig ?? const PdfRenderingConfig(),
       super(PdfReaderInitialState()) {
    on<OpenPdfEvent>(_onOpenPdf);
    on<ChangePageEvent>(_onChangePage);
    on<SelectTextEvent>(_onSelectText);
    on<AddBookmarkEvent>(_onAddBookmark);
    on<SaveScrollPositionEvent>(_onSaveScrollPosition);
  }

  @override
  Future<void> close() {
    _cacheService.clearCache();
    return super.close();
  }

  Future<void> _onOpenPdf(
    OpenPdfEvent event,
    Emitter<PdfReaderState> emit,
  ) async {
    emit(PdfReaderLoadingState());
    try {
      final result = await RetryLogic.retry(
        operation: () => _validateAndOpenPdfUseCase(event.bookId),
        maxAttempts: 2,
        shouldRetry: (e) => e is DatabaseError,
      );

      if (!result.isValid) {
        emit(_mapValidationErrorToState(result));
        return;
      }

      final book = result.book!;
      _cacheService.clearCache();

      final useLazyLoading = _renderingConfig.shouldUseLazyLoading(
        book.totalPages,
      );

      emit(
        PdfReaderLoadedState(
          book: book,
          currentPage: book.currentPage,
          renderingConfig: _renderingConfig,
          useLazyLoading: useLazyLoading,
        ),
      );

      if (_renderingConfig.enableProgressiveRendering) {
        _cacheService.preloadAdjacentPages(book.currentPage, book.totalPages);
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);

      final error = e is AppError ? e : const UnknownError();
      emit(
        PdfReaderErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry,
        ),
      );
    }
  }

  PdfReaderErrorState _mapValidationErrorToState(ValidatedPdfResult result) {
    switch (result.status) {
      case ValidatedPdfStatus.notFound:
        return const PdfReaderErrorState(
          errorCode: AppErrorCode.fileNotFound,
          message: null,
          canRetry: false,
        );
      case ValidatedPdfStatus.invalid:
        final errorCode = _mapValidationErrorToAppError(result.validationError);
        return PdfReaderErrorState(
          errorCode: errorCode,
          message: null,
          canRetry: false,
        );
      case ValidatedPdfStatus.success:
        return const PdfReaderErrorState(
          errorCode: AppErrorCode.unknown,
          message: null,
          canRetry: false,
        );
    }
  }

  AppErrorCode _mapValidationErrorToAppError(PdfValidationError? error) {
    switch (error) {
      case PdfValidationError.fileNotFound:
        return AppErrorCode.fileNotFound;
      case PdfValidationError.emptyFile:
      case PdfValidationError.tooSmall:
      case PdfValidationError.invalidFormat:
        return AppErrorCode.fileCorrupted;
      case PdfValidationError.unknown:
      case null:
        return AppErrorCode.fileCorrupted;
    }
  }

  Future<void> _onChangePage(
    ChangePageEvent event,
    Emitter<PdfReaderState> emit,
  ) async {
    if (state is PdfReaderLoadedState) {
      final currentState = state as PdfReaderLoadedState;

      emit(currentState.copyWith(currentPage: event.pageNumber));

      if (_renderingConfig.enableProgressiveRendering) {
        _cacheService.preloadAdjacentPages(
          event.pageNumber,
          currentState.book.totalPages,
        );
      }

      try {
        await _updateReadingProgressUseCase(
          bookId: currentState.book.id,
          currentPage: event.pageNumber,
        );
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
        final error = e is AppError ? e : const UnknownError();
        emit(
          PdfReaderErrorState(
            errorCode: error.code,
            message: error.message,
            canRetry: error.canRetry,
          ),
        );
      }
    }
  }

  Future<void> _onSelectText(
    SelectTextEvent event,
    Emitter<PdfReaderState> emit,
  ) async {
    if (state is PdfReaderLoadedState) {
      final currentState = state as PdfReaderLoadedState;
      emit(currentState.copyWith(selectedText: event.selectedText));
    }
  }

  Future<void> _onAddBookmark(
    AddBookmarkEvent event,
    Emitter<PdfReaderState> emit,
  ) async {
    if (state is PdfReaderLoadedState) {
      final currentState = state as PdfReaderLoadedState;

      try {
        final bookmark = Bookmark(
          id: const Uuid().v4(),
          pdfBookId: currentState.book.id,
          pageNumber: event.pageNumber,
          note: event.note,
          createdAt: DateTime.now(),
        );

        await _saveBookmarkUseCase(bookmark);
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
        final error = e is AppError ? e : const UnknownError();
        emit(
          PdfReaderErrorState(
            errorCode: error.code,
            message: error.message,
            canRetry: error.canRetry,
          ),
        );
      }
    }
  }

  void _onSaveScrollPosition(
    SaveScrollPositionEvent event,
    Emitter<PdfReaderState> emit,
  ) {
    if (state is PdfReaderLoadedState) {
      final currentState = state as PdfReaderLoadedState;
      emit(currentState.copyWith(scrollPosition: event.scrollPosition));
    }
  }
}
