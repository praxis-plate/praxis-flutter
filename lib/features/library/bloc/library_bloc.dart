import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/exceptions/app_exception.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/core/utils/retry_logic.dart';
import 'package:codium/domain/models/pdf_book/pdf_book_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetPdfListUseCase _getPdfListUseCase;
  final ImportPdfUseCase _importPdfUseCase;
  final DeletePdfUseCase _deletePdfUseCase;
  final ToggleFavoritePdfUseCase _toggleFavoritePdfUseCase;

  LibraryBloc({
    required GetPdfListUseCase getPdfListUseCase,
    required ImportPdfUseCase importPdfUseCase,
    required DeletePdfUseCase deletePdfUseCase,
    required ToggleFavoritePdfUseCase toggleFavoritePdfUseCase,
  }) : _getPdfListUseCase = getPdfListUseCase,
       _importPdfUseCase = importPdfUseCase,
       _deletePdfUseCase = deletePdfUseCase,
       _toggleFavoritePdfUseCase = toggleFavoritePdfUseCase,
       super(LibraryInitialState()) {
    on<LoadLibraryEvent>(_onLoadLibrary);
    on<ImportPdfEvent>(_onImportPdf);
    on<DeletePdfEvent>(_onDeletePdf);
    on<SearchLibraryEvent>(_onSearchLibrary);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadLibrary(
    LoadLibraryEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoadingState());
    try {
      final result = await RetryLogic.retry(
        operation: () => _getPdfListUseCase(),
        maxAttempts: 2,
        shouldRetry: (e) => e is DatabaseError,
      );

      result.when(
        success: (books) {
          emit(LibraryLoadedState(books: books, filteredBooks: books));
        },
        failure: (failure) {
          emit(
            LibraryErrorState(
              errorCode: failure.code,
              message: failure.message,
            ),
          );
        },
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError ? e : const UnknownError();
      emit(
        LibraryErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry,
        ),
      );
    }
  }

  Future<void> _onImportPdf(
    ImportPdfEvent event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      final fileName = event.filePath.split('/').last.replaceAll('.pdf', '');
      await _importPdfUseCase(event.filePath, fileName);
      add(LoadLibraryEvent());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError ? e : const UnknownError();
      emit(
        LibraryErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry,
        ),
      );
    }
  }

  Future<void> _onDeletePdf(
    DeletePdfEvent event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _deletePdfUseCase(event.bookId);
      add(LoadLibraryEvent());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError ? e : const UnknownError();
      emit(
        LibraryErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry,
        ),
      );
    }
  }

  Future<void> _onSearchLibrary(
    SearchLibraryEvent event,
    Emitter<LibraryState> emit,
  ) async {
    if (state is LibraryLoadedState) {
      final currentState = state as LibraryLoadedState;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(
          LibraryLoadedState(
            books: currentState.books,
            filteredBooks: currentState.books,
            searchQuery: query,
          ),
        );
      } else {
        final filtered = currentState.books.where((book) {
          final titleMatch = book.title.toLowerCase().contains(query);
          final authorMatch =
              book.author?.toLowerCase().contains(query) ?? false;
          return titleMatch || authorMatch;
        }).toList();

        emit(
          LibraryLoadedState(
            books: currentState.books,
            filteredBooks: filtered,
            searchQuery: query,
          ),
        );
      }
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _toggleFavoritePdfUseCase(event.bookId);
      add(LoadLibraryEvent());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError ? e : const UnknownError();
      emit(
        LibraryErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry,
        ),
      );
    }
  }
}
