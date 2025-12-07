import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/repositories/i_explanation_repository.dart';

class DeleteExplanationUseCase {
  final IExplanationRepository _explanationRepository;

  DeleteExplanationUseCase(this._explanationRepository);

  Future<Result<void>> call(int explanationId) async {
    return await _explanationRepository.deleteExplanation(explanationId);
  }
}
