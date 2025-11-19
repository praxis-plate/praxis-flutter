import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetPdfListUseCase {
  final IPdfRepository _pdfRepository;

  GetPdfListUseCase(this._pdfRepository);

  Future<List<PdfBook>> execute() async {
    try {
      final books = await _pdfRepository.getAllBooks();
      return books;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
