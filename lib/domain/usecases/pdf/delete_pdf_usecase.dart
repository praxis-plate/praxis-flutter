import 'package:codium/domain/repositories/pdf_repository.dart';

class DeletePdfUseCase {
  final IPdfRepository _pdfRepository;

  const DeletePdfUseCase(this._pdfRepository);

  Future<void> call(String bookId) async {
    await _pdfRepository.deleteBook(bookId);
  }
}
