import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetPdfBookByIdUseCase {
  final IPdfRepository _pdfRepository;

  GetPdfBookByIdUseCase(this._pdfRepository);

  Future<PdfBook?> execute(String bookId) async {
    try {
      if (bookId.isEmpty) {
        throw ArgumentError('Book ID cannot be empty');
      }

      final book = await _pdfRepository.getBookById(bookId);
      return book;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
