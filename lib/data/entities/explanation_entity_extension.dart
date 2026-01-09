import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/explanation/create_explanation_model.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';

extension ExplanationEntityExtension on ExplanationEntity {
  ExplanationModel toDomain() {
    return ExplanationModel(
      id: id,
      selectedText: selectedText,
      explanation: explanation,
      sources: sources,
      createdAt: createdAt,
    );
  }
}

extension CreateExplanationModelExtension on CreateExplanationModel {
  ExplanationCompanion toCompanion() {
    return ExplanationCompanion.insert(
      selectedText: selectedText,
      explanation: explanation,
      sources: sources,
      createdAt: DateTime.now(),
    );
  }
}
