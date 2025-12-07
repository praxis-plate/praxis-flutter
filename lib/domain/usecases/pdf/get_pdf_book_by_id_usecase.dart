import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/pdf_book/pdf_book_model.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';

class GetPdfBookByIdUseCase {
  final IPdfRepository _pdfRepository;

  GetPdfBookByIdUseCase(this._pdfRepository);

  Future<Result<PdfBookModel?>> call(int bookId) async {
    return await _pdfRepository.getBookById(bookId);
  }
}
