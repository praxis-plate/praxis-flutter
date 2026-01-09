import 'package:codium/data/database/app_database.dart';

abstract interface class IExplanationLocalDataSource {
  Future<List<ExplanationEntity>> getAllExplanations();

  Future<ExplanationEntity?> getExplanationById(int id);

  Future<List<ExplanationEntity>> searchExplanations(String query);

  Future<ExplanationEntity> insertExplanation(ExplanationCompanion entry);

  Future<void> updateExplanation(ExplanationCompanion entry);

  Future<void> deleteExplanation(int id);
}
