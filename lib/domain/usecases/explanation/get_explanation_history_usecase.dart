import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';
import 'package:codium/domain/repositories/i_explanation_repository.dart';

class GetExplanationHistoryUseCase {
  final IExplanationRepository _explanationRepository;

  GetExplanationHistoryUseCase(this._explanationRepository);

  Future<Result<List<ExplanationModel>>> call() async {
    return await _explanationRepository.getAllExplanations();
  }
}
