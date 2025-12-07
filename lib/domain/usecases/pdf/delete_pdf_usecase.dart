import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';

class DeletePdfUseCase {
  final IPdfRepository _pdfRepository;

  const DeletePdfUseCase(this._pdfRepository);

  Future<Result<void>> call(int bookId) async {
    return await _pdfRepository.delete(bookId);
  }
}
