import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/domain/repositories/ai_repository.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

class ExplainTextUseCase {
  final IAiRepository _aiRepository;
  final IStorageRepository _storageRepository;

  ExplainTextUseCase(this._aiRepository, this._storageRepository);

  Future<Explanation> execute({
    required String selectedText,
    required String context,
    required String pdfBookId,
    required int pageNumber,
  }) async {
    try {
      if (selectedText.isEmpty) {
        throw ArgumentError('Selected text cannot be empty');
      }

      final explanationText = await _aiRepository.explainText(
        text: selectedText,
        context: context,
      );

      List<SearchSource> sources = [];
      try {
        sources = await _aiRepository.searchWeb(selectedText);
      } catch (e) {
        GetIt.I<Talker>().warning(
          'Web search failed, continuing without sources: $e',
        );
      }

      final explanation = Explanation(
        id: const Uuid().v4(),
        pdfBookId: pdfBookId,
        pageNumber: pageNumber,
        selectedText: selectedText,
        explanation: explanationText,
        sources: sources,
        createdAt: DateTime.now(),
      );

      await _storageRepository.saveExplanation(explanation);

      return explanation;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
