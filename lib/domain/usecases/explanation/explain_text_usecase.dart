import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';
import 'package:codium/domain/repositories/i_explanation_repository.dart';

class ExplainTextUseCase {
  final IExplanationRepository _explanationRepository;

  ExplainTextUseCase(this._explanationRepository);

  Future<Result<List<ExplanationModel>>> call() async {
    return await _explanationRepository.getAllExplanations();
  }
}
