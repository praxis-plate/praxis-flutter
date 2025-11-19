import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetExplanationHistoryUseCase {
  final IStorageRepository _storageRepository;

  GetExplanationHistoryUseCase(this._storageRepository);

  Future<List<Explanation>> execute() async {
    try {
      final explanations = await _storageRepository.getAllExplanations();
      return explanations;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
