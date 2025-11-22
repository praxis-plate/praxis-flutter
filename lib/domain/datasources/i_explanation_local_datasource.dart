import 'package:codium/domain/models/ai_explanation/ai_explanation.dart';

abstract interface class IExplanationLocalDataSource {
  Future<List<Explanation>> getAllExplanations();

  Future<Explanation?> getExplanationById(String id);

  Future<List<Explanation>> getExplanationsByPdfId(String pdfBookId);

  Future<List<Explanation>> searchExplanations(String query);

  Future<void> insertExplanation(Explanation explanation);

  Future<void> updateExplanation(Explanation explanation);

  Future<void> deleteExplanation(String id);
}
