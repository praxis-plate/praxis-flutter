import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/models/pdf_reader/bookmark.dart';
import 'package:codium/domain/usecases/get_pdf_book_by_id_usecase.dart';
import 'package:codium/domain/usecases/save_bookmark_usecase.dart';
import 'package:codium/domain/usecases/update_reading_progress_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'pdf_reader_event.dart';
part 'pdf_reader_state.dart';

class PdfReaderBloc extends Bloc<PdfReaderEvent, PdfReaderState> {
  final GetPdfBookByIdUseCase _getPdfBookByIdUseCase;
  final UpdateReadingProgressUseCase _updateReadingProgressUseCase;
  final SaveBookmarkUseCase _saveBookmarkUseCase;

  PdfReaderBloc({
    required GetPdfBookByIdUseCase getPdfBookByIdUseCase,
    required UpdateReadingProgressUseCase updateReadingProgressUseCase,
    required SaveBookmarkUseCase saveBookmarkUseCase,
  }) : _getPdfBookByIdUseCase = getPdfBookByIdUseCase,
       _updateReadingProgressUseCase = updateReadingProgressUseCase,
       _saveBookmarkUseCase = saveBookmarkUseCase,
       super(PdfReaderInitialState()) {
    on<OpenPdfEvent>(_onOpenPdf);
    on<ChangePageEvent>(_onChangePage);
    on<SelectTextEvent>(_onSelectText);
    on<AddBookmarkEvent>(_onAddBookmark);
  }

  Future<void> _onOpenPdf(
    OpenPdfEvent event,
    Emitter<PdfReaderState> emit,
  ) async {
    emit(PdfReaderLoadingState());
    try {
      final book = await _getPdfBookByIdUseCase.execute(event.bookId);
      if (book == null) {
        emit(const PdfReaderErrorState('PDF book not found'));
        return;
      }
      emit(PdfReaderLoadedState(book: book, currentPage: book.currentPage));
    } catch (e) {
      emit(PdfReaderErrorState(e.toString()));
    }
  }

  Future<void> _onChangePage(
    ChangePageEvent event,
    Emitter<PdfReaderState> emit,
  ) async {
    if (state is PdfReaderLoadedState) {
      final currentState = state as PdfReaderLoadedState;

      emit(currentState.copyWith(currentPage: event.pageNumber));

      try {
        await _updateReadingProgressUseCase.execute(
          bookId: currentState.book.id,
          currentPage: event.pageNumber,
        );
      } catch (e) {
        emit(PdfReaderErrorState(e.toString()));
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

        await _saveBookmarkUseCase.execute(bookmark);
      } catch (e) {
        emit(PdfReaderErrorState(e.toString()));
      }
    }
  }
}
