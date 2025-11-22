import 'package:codium/core/utils/pdf_validator.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';

class ValidateAndOpenPdfUseCase {
  final IPdfRepository _repository;

  ValidateAndOpenPdfUseCase(this._repository);

  Future<ValidatedPdfResult> call(String bookId) async {
    final book = await _repository.getBookById(bookId);

    if (book == null) {
      return ValidatedPdfResult.notFound();
    }

    final validationResult = await PdfValidator.validate(book.filePath);

    if (!validationResult.isValid) {
      return ValidatedPdfResult.invalid(
        book: book,
        validationError: validationResult.error,
        errorMessage: validationResult.message,
      );
    }

    return ValidatedPdfResult.success(book: book);
  }
}

class ValidatedPdfResult {
  final PdfBook? book;
  final bool isValid;
  final PdfValidationError? validationError;
  final String? errorMessage;
  final ValidatedPdfStatus status;

  ValidatedPdfResult._({
    this.book,
    required this.isValid,
    this.validationError,
    this.errorMessage,
    required this.status,
  });

  factory ValidatedPdfResult.success({required PdfBook book}) {
    return ValidatedPdfResult._(
      book: book,
      isValid: true,
      status: ValidatedPdfStatus.success,
    );
  }

  factory ValidatedPdfResult.notFound() {
    return ValidatedPdfResult._(
      isValid: false,
      status: ValidatedPdfStatus.notFound,
      errorMessage: 'PDF book not found',
    );
  }

  factory ValidatedPdfResult.invalid({
    PdfBook? book,
    PdfValidationError? validationError,
    String? errorMessage,
  }) {
    return ValidatedPdfResult._(
      book: book,
      isValid: false,
      validationError: validationError,
      errorMessage: errorMessage,
      status: ValidatedPdfStatus.invalid,
    );
  }
}

enum ValidatedPdfStatus { success, notFound, invalid }
