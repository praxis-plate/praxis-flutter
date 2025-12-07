import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';

class UpdateReadingProgressUseCase {
  final IPdfRepository _pdfRepository;

  UpdateReadingProgressUseCase(this._pdfRepository);

  Future<Result<void>> call({
    required int bookId,
    required int currentPage,
  }) async {
    if (currentPage < 0) {
      return const Failure(
        AppFailure(
          code: AppErrorCode.validationInvalid,
          message: 'Current page must be non-negative',
          canRetry: false,
        ),
      );
    }

    return await _pdfRepository.updateReadingProgress(bookId, currentPage);
  }
}
