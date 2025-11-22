class GeminiException implements Exception {
  final String message;
  const GeminiException(this.message);

  @override
  String toString() => message;
}

class GeminiRateLimitException extends GeminiException {
  const GeminiRateLimitException(super.message);
}

class GeminiInvalidApiKeyException extends GeminiException {
  const GeminiInvalidApiKeyException(super.message);
}

class GeminiModelNotAvailableException extends GeminiException {
  const GeminiModelNotAvailableException(super.message);
}

class GeminiEmptyResponseException extends GeminiException {
  const GeminiEmptyResponseException(super.message);
}
