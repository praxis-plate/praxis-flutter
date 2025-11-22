class PdfException implements Exception {
  final String message;
  const PdfException(this.message);

  @override
  String toString() => message;
}

class PdfInvalidFormatException extends PdfException {
  const PdfInvalidFormatException(super.message);
}

class PdfRenderException extends PdfException {
  const PdfRenderException(super.message);
}
