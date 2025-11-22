abstract interface class IGeminiDataSource {
  Future<String> explainText({required String text, required String context});
}
