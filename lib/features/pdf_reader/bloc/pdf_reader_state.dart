part of 'pdf_reader_bloc.dart';

abstract class PdfReaderState extends Equatable {
  const PdfReaderState();

  @override
  List<Object?> get props => [];
}

class PdfReaderInitialState extends PdfReaderState {}

class PdfReaderLoadingState extends PdfReaderState {}

class PdfReaderLoadedState extends PdfReaderState {
  final PdfBookModel book;
  final int currentPage;
  final String? selectedText;
  final PdfRenderingConfig renderingConfig;
  final bool useLazyLoading;
  final double? scrollPosition;

  const PdfReaderLoadedState({
    required this.book,
    required this.currentPage,
    this.selectedText,
    this.renderingConfig = const PdfRenderingConfig(),
    this.useLazyLoading = false,
    this.scrollPosition,
  });

  @override
  List<Object?> get props => [
    book,
    currentPage,
    selectedText,
    renderingConfig,
    useLazyLoading,
    scrollPosition,
  ];

  PdfReaderLoadedState copyWith({
    PdfBookModel? book,
    int? currentPage,
    String? selectedText,
    PdfRenderingConfig? renderingConfig,
    bool? useLazyLoading,
    double? scrollPosition,
  }) {
    return PdfReaderLoadedState(
      book: book ?? this.book,
      currentPage: currentPage ?? this.currentPage,
      selectedText: selectedText ?? this.selectedText,
      renderingConfig: renderingConfig ?? this.renderingConfig,
      useLazyLoading: useLazyLoading ?? this.useLazyLoading,
      scrollPosition: scrollPosition ?? this.scrollPosition,
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
