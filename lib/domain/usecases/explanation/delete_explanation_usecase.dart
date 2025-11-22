import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DeleteExplanationUseCase {
  final IStorageRepository _storageRepository;

  DeleteExplanationUseCase(this._storageRepository);

  Future<void> call(String explanationId) async {
    try {
      if (explanationId.isEmpty) {
        throw ArgumentError('Explanation ID cannot be empty');
      }

      await _storageRepository.deleteExplanation(explanationId);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
