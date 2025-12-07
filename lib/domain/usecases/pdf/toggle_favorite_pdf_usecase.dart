import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/pdf_book/update_pdf_book_model.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';

class ToggleFavoritePdfUseCase {
  final IPdfRepository _pdfRepository;

  const ToggleFavoritePdfUseCase(this._pdfRepository);

  Future<Result<void>> call(int bookId) async {
    final bookResult = await _pdfRepository.getBookById(bookId);

    return bookResult.when(
      success: (book) async {
        if (book == null) {
          return const Failure(
            AppFailure(
              code: AppErrorCode.apiNotFound,
              message: 'Book not found',
              canRetry: false,
            ),
          );
        }

        final updateModel = UpdatePdfBookModel(
          id: bookId,
          isFavorite: !book.isFavorite,
        );

        return await _pdfRepository.update(updateModel);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
