import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_explanation_local_datasource.dart';

class ExplanationLocalDataSource implements IExplanationLocalDataSource {
  final AppDatabase _db;

  const ExplanationLocalDataSource(this._db);

  @override
  Future<List<ExplanationEntity>> getAllExplanations() async {
    return await _db.managers.explanation.get();
  }

  @override
  Future<ExplanationEntity?> getExplanationById(int id) async {
    return await _db.managers.explanation
        .filter((f) => f.id(id))
        .getSingleOrNull();
  }

  @override
  Future<List<ExplanationEntity>> getExplanationsByPdfId(int pdfBookId) async {
    return await _db.managers.explanation
        .filter((f) => f.pdfBookId.id(pdfBookId))
        .get();
  }

  @override
  Future<List<ExplanationEntity>> searchExplanations(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final allExplanations = await getAllExplanations();

    return allExplanations
        .where(
          (explanation) =>
              explanation.selectedText.toLowerCase().contains(lowercaseQuery) ||
              explanation.explanation.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  @override
  Future<ExplanationEntity> insertExplanation(ExplanationEntity entry) async {
    return await _db.into(_db.explanation).insertReturning(entry);
  }

  @override
  Future<void> updateExplanation(ExplanationCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Bookmark id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(
      _db.explanation,
    )..where((t) => t.id.equals(id))).write(entry);
  }

  @override
  Future<void> deleteExplanation(int id) async {
    await _db.managers.explanation.filter((f) => f.id(id)).delete();
  }
}
