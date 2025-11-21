import 'dart:io';

class PdfValidator {
  static Future<PdfValidationResult> validate(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return PdfValidationResult(
          isValid: false,
          error: PdfValidationError.fileNotFound,
          message: 'File not found: $filePath',
        );
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        return PdfValidationResult(
          isValid: false,
          error: PdfValidationError.emptyFile,
          message: 'File is empty',
        );
      }

      if (fileSize < 10) {
        return PdfValidationResult(
          isValid: false,
          error: PdfValidationError.tooSmall,
          message: 'File is too small to be a valid PDF',
        );
      }

      // Проверка PDF заголовка
      final bytes = await file.openRead(0, 5).first;
      final header = String.fromCharCodes(bytes);
      if (!header.startsWith('%PDF')) {
        return PdfValidationResult(
          isValid: false,
          error: PdfValidationError.invalidFormat,
          message: 'File does not have a valid PDF header',
        );
      }

      return PdfValidationResult(isValid: true);
    } catch (e) {
      return PdfValidationResult(
        isValid: false,
        error: PdfValidationError.unknown,
        message: 'Validation error: $e',
      );
    }
  }

  static Future<bool> hasValidPdfHeader(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      final bytes = await file.openRead(0, 5).first;
      final header = String.fromCharCodes(bytes);
      return header.startsWith('%PDF');
    } catch (e) {
      return false;
    }
  }
}

class PdfValidationResult {
  final bool isValid;
  final PdfValidationError? error;
  final String? message;

  PdfValidationResult({required this.isValid, this.error, this.message});
}

enum PdfValidationError {
  fileNotFound,
  emptyFile,
  tooSmall,
  invalidFormat,
  unknown,
}
