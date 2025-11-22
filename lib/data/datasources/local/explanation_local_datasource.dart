import 'dart:convert';

import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/domain/datasources/i_explanation_local_datasource.dart';
import 'package:codium/domain/models/ai_explanation/ai_explanation.dart';
import 'package:drift/drift.dart';

class ExplanationLocalDataSource implements IExplanationLocalDataSource {
  final AppDatabase _db;

  ExplanationLocalDataSource(this._db);

  @override
  Future<List<Explanation>> getAllExplanations() async {
    final entities = await _db.managers.explanations.get();
    return entities.map(_entityToDomain).toList();
  }

  @override
  Future<Explanation?> getExplanationById(String id) async {
    final entity = await _db.managers.explanations
        .filter((f) => f.id(id))
        .getSingleOrNull();

    if (entity == null) return null;
    return _entityToDomain(entity);
  }

  @override
  Future<List<Explanation>> getExplanationsByPdfId(String pdfBookId) async {
    final entities = await _db.managers.explanations
        .filter((f) => f.pdfBookId.id(pdfBookId))
        .get();

    return entities.map(_entityToDomain).toList();
  }

  @override
  Future<List<Explanation>> searchExplanations(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final allExplanations = await getAllExplanations();

    return allExplanations.where((explanation) {
      return explanation.selectedText.toLowerCase().contains(lowercaseQuery) ||
          explanation.explanation.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<void> insertExplanation(Explanation explanation) async {
    await _db.managers.explanations.create(
      (o) => o(
        id: explanation.id,
        pdfBookId: explanation.pdfBookId,
        pageNumber: explanation.pageNumber,
        selectedText: explanation.selectedText,
        explanation: explanation.explanation,
        sources: _encodeSources(explanation.sources),
        createdAt: explanation.createdAt,
      ),
    );
  }

  @override
  Future<void> updateExplanation(Explanation explanation) async {
    await _db.managers.explanations
        .filter((f) => f.id(explanation.id))
        .update(
          (o) => o(
            pdfBookId: Value(explanation.pdfBookId),
            pageNumber: Value(explanation.pageNumber),
            selectedText: Value(explanation.selectedText),
            explanation: Value(explanation.explanation),
            sources: Value(_encodeSources(explanation.sources)),
            createdAt: Value(explanation.createdAt),
          ),
        );
  }

  @override
  Future<void> deleteExplanation(String id) async {
    await _db.managers.explanations.filter((f) => f.id(id)).delete();
  }

  Explanation _entityToDomain(ExplanationEntity entity) {
    return Explanation(
      id: entity.id,
      pdfBookId: entity.pdfBookId,
      pageNumber: entity.pageNumber,
      selectedText: entity.selectedText,
      explanation: entity.explanation,
      sources: _decodeSources(entity.sources),
      createdAt: entity.createdAt,
    );
  }

  String _encodeSources(List<SearchSource> sources) {
    final sourcesList = sources.map((source) => source.toJson()).toList();
    return jsonEncode(sourcesList);
  }

  List<SearchSource> _decodeSources(String sourcesJson) {
    if (sourcesJson.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(sourcesJson);
      return decoded
          .map((json) => SearchSource.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
