import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UpdateReadingProgressUseCase {
  final IPdfRepository _pdfRepository;

  UpdateReadingProgressUseCase(this._pdfRepository);

  Future<void> call({required String bookId, required int currentPage}) async {
    try {
      if (bookId.isEmpty) {
        throw ArgumentError('Book ID cannot be empty');
      }

      if (currentPage < 0) {
        throw ArgumentError('Current page must be non-negative');
      }

      await _pdfRepository.updateReadingProgress(bookId, currentPage);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
