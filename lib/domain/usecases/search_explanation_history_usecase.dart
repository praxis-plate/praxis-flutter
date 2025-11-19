import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SearchExplanationHistoryUseCase {
  final IStorageRepository _storageRepository;

  SearchExplanationHistoryUseCase(this._storageRepository);

  Future<List<Explanation>> execute(String query) async {
    try {
      if (query.isEmpty) {
        return await _storageRepository.getAllExplanations();
      }

      final explanations = await _storageRepository.searchExplanations(query);
      return explanations;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
