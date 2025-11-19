import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:codium/domain/usecases/get_pdf_list_usecase.dart';
import 'package:codium/domain/usecases/import_pdf_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetPdfListUseCase _getPdfListUseCase;
  final ImportPdfUseCase _importPdfUseCase;
  final IPdfRepository _pdfRepository;

  LibraryBloc({
    required GetPdfListUseCase getPdfListUseCase,
    required ImportPdfUseCase importPdfUseCase,
    required IPdfRepository pdfRepository,
  }) : _getPdfListUseCase = getPdfListUseCase,
       _importPdfUseCase = importPdfUseCase,
       _pdfRepository = pdfRepository,
       super(LibraryInitialState()) {
    on<LoadLibraryEvent>(_onLoadLibrary);
    on<ImportPdfEvent>(_onImportPdf);
    on<DeletePdfEvent>(_onDeletePdf);
    on<SearchLibraryEvent>(_onSearchLibrary);
  }

  Future<void> _onLoadLibrary(
    LoadLibraryEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoadingState());
    try {
      final books = await _getPdfListUseCase.execute();
      emit(LibraryLoadedState(books: books, filteredBooks: books));
    } catch (e) {
      emit(LibraryErrorState(e.toString()));
    }
  }

  Future<void> _onImportPdf(
    ImportPdfEvent event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _importPdfUseCase.execute(event.filePath);
      add(LoadLibraryEvent());
    } catch (e) {
      emit(LibraryErrorState(e.toString()));
    }
  }

  Future<void> _onDeletePdf(
    DeletePdfEvent event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _pdfRepository.deleteBook(event.bookId);
      add(LoadLibraryEvent());
    } catch (e) {
      emit(LibraryErrorState(e.toString()));
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
}
