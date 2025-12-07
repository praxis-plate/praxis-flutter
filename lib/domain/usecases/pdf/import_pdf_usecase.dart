import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/pdf_book/create_pdf_book_model.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';

class ImportPdfUseCase {
  final IPdfRepository _pdfRepository;

  ImportPdfUseCase(this._pdfRepository);

  Future<Result<void>> call(String filePath, String title) async {
    if (filePath.isEmpty) {
      return const Failure(
        AppFailure(
          code: AppErrorCode.validationInvalid,
          message: 'File path cannot be empty',
          canRetry: false,
        ),
      );
    }

    if (!filePath.toLowerCase().endsWith('.pdf')) {
      return const Failure(
        AppFailure(
          code: AppErrorCode.validationInvalid,
          message: 'File must be a PDF',
          canRetry: false,
        ),
      );
    }

    final model = CreatePdfBookModel(
      title: title,
      filePath: filePath,
      totalPages: 0,
    );

    return await _pdfRepository.create(model);
  }
}
