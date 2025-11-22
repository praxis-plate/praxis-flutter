import 'package:codium/domain/repositories/pdf_repository.dart';

class ToggleFavoritePdfUseCase {
  final IPdfRepository _pdfRepository;

  const ToggleFavoritePdfUseCase(this._pdfRepository);

  Future<void> call(String bookId) async {
    final book = await _pdfRepository.getBookById(bookId);
    if (book != null) {
      final updatedBook = book.copyWith(isFavorite: !book.isFavorite);
      await _pdfRepository.updateBook(updatedBook);
    }
  }
}
