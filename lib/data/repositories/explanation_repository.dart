import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/explanation_entity_extension.dart';
import 'package:codium/domain/datasources/i_explanation_local_datasource.dart';
import 'package:codium/domain/models/explanation/create_explanation_model.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';
import 'package:codium/domain/repositories/i_explanation_repository.dart';

class ExplanationRepository implements IExplanationRepository {
  final IExplanationLocalDataSource _localDataSource;

  const ExplanationRepository(this._localDataSource);

  @override
  Future<Result<List<ExplanationModel>>> getAllExplanations() async {
    try {
      final entities = await _localDataSource.getAllExplanations();
      final explanations = entities.map((e) => e.toDomain()).toList();
      return Success(explanations);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> saveExplanation(
    CreateExplanationModel explanation,
  ) async {
    try {
      await _localDataSource.insertExplanation(explanation.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> deleteExplanation(int explanationId) async {
    try {
      await _localDataSource.deleteExplanation(explanationId);
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<List<ExplanationModel>>> searchExplanations(
    String query,
  ) async {
    try {
      final entities = await _localDataSource.searchExplanations(query);
      final explanations = entities.map((e) => e.toDomain()).toList();
      return Success(explanations);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
