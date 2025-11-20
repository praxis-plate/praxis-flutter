part of 'pdf_reader_bloc.dart';

abstract class PdfReaderState extends Equatable {
  const PdfReaderState();

  @override
  List<Object?> get props => [];
}

class PdfReaderInitialState extends PdfReaderState {}

class PdfReaderLoadingState extends PdfReaderState {}

class PdfReaderLoadedState extends PdfReaderState {
  final PdfBook book;
  final int currentPage;
  final String? selectedText;

  const PdfReaderLoadedState({
    required this.book,
    required this.currentPage,
    this.selectedText,
  });

  @override
  List<Object?> get props => [book, currentPage, selectedText];

  PdfReaderLoadedState copyWith({
    PdfBook? book,
    int? currentPage,
    String? selectedText,
  }) {
    return PdfReaderLoadedState(
      book: book ?? this.book,
      currentPage: currentPage ?? this.currentPage,
      selectedText: selectedText ?? this.selectedText,
    );
  }
}

class PdfReaderErrorState extends PdfReaderState {
  final AppErrorCode errorCode;
  final String? message;
  final bool canRetry;

  const PdfReaderErrorState({
    required this.errorCode,
    this.message,
    this.canRetry = false,
  });

  @override
  List<Object?> get props => [errorCode, message, canRetry];
}
