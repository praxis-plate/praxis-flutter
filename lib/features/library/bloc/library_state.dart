part of 'library_bloc.dart';

sealed class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

final class LibraryInitialState extends LibraryState {}

final class LibraryLoadingState extends LibraryState {}

final class LibraryLoadedState extends LibraryState {
  final List<PdfBook> books;
  final List<PdfBook> filteredBooks;
  final String searchQuery;

  const LibraryLoadedState({
    required this.books,
    required this.filteredBooks,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [books, filteredBooks, searchQuery];
}

final class LibraryErrorState extends LibraryState {
  final AppErrorCode errorCode;
  final String? message;
  final bool canRetry;

  const LibraryErrorState({
    required this.errorCode,
    this.message,
    this.canRetry = false,
  });

  @override
  List<Object?> get props => [errorCode, message, canRetry];
}
