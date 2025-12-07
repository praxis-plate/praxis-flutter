import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/pdf_book/pdf_book_model.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';

class GetPdfListUseCase {
  final IPdfRepository _pdfRepository;

  GetPdfListUseCase(this._pdfRepository);

  Future<Result<List<PdfBookModel>>> call() async {
    return await _pdfRepository.getAllBooks();
  }
}
