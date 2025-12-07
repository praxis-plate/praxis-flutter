import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';
import 'package:codium/domain/repositories/i_explanation_repository.dart';

class SearchExplanationHistoryUseCase {
  final IExplanationRepository _explanationRepository;

  SearchExplanationHistoryUseCase(this._explanationRepository);

  Future<Result<List<ExplanationModel>>> call(String query) async {
    return await _explanationRepository.getAllExplanations();
  }
}
