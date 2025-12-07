part of 'pdf_reader_bloc.dart';

abstract class PdfReaderEvent extends Equatable {
  const PdfReaderEvent();

  @override
  List<Object?> get props => [];
}

class OpenPdfEvent extends PdfReaderEvent {
  final int bookId;

  const OpenPdfEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class ChangePageEvent extends PdfReaderEvent {
  final int pageNumber;

  const ChangePageEvent(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class SelectTextEvent extends PdfReaderEvent {
  final String selectedText;
  final int pageNumber;

  const SelectTextEvent({required this.selectedText, required this.pageNumber});

  @override
  List<Object?> get props => [selectedText, pageNumber];
}

class AddBookmarkEvent extends PdfReaderEvent {
  final int pageNumber;
  final String? note;

  const AddBookmarkEvent({required this.pageNumber, this.note});

  @override
  List<Object?> get props => [pageNumber, note];
}

class SaveScrollPositionEvent extends PdfReaderEvent {
  final double scrollPosition;

  const SaveScrollPositionEvent(this.scrollPosition);

  @override
  List<Object?> get props => [scrollPosition];
}
