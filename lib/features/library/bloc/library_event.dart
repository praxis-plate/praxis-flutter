part of 'library_bloc.dart';

sealed class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class LoadLibraryEvent extends LibraryEvent {}

class ImportPdfEvent extends LibraryEvent {
  final String filePath;

  const ImportPdfEvent(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class DeletePdfEvent extends LibraryEvent {
  final String bookId;

  const DeletePdfEvent(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class SearchLibraryEvent extends LibraryEvent {
  final String query;

  const SearchLibraryEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleFavoriteEvent extends LibraryEvent {
  final String bookId;

  const ToggleFavoriteEvent(this.bookId);

  @override
  List<Object> get props => [bookId];
}
