import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/explanation/create_explanation_model.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';

abstract interface class IExplanationRepository {
  Future<Result<List<ExplanationModel>>> getAllExplanations();
  Future<Result<List<ExplanationModel>>> getExplanationsByPdfId(int pdfBookId);
  Future<Result<void>> saveExplanation(CreateExplanationModel explanation);
  Future<Result<void>> deleteExplanation(int explanationId);
  Future<Result<List<ExplanationModel>>> searchExplanations(String query);
}
