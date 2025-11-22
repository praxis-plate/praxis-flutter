import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ImportPdfUseCase {
  final IPdfRepository _pdfRepository;

  ImportPdfUseCase(this._pdfRepository);

  Future<void> call(String filePath) async {
    try {
      if (filePath.isEmpty) {
        throw ArgumentError('File path cannot be empty');
      }

      if (!filePath.toLowerCase().endsWith('.pdf')) {
        throw ArgumentError('File must be a PDF');
      }

      await _pdfRepository.importPdf(filePath);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
