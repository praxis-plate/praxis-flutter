import 'package:codium/domain/models/pdf_reader/bookmark.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SaveBookmarkUseCase {
  final IStorageRepository _storageRepository;

  SaveBookmarkUseCase(this._storageRepository);

  Future<void> execute(Bookmark bookmark) async {
    try {
      if (bookmark.id.isEmpty) {
        throw ArgumentError('Bookmark ID cannot be empty');
      }

      if (bookmark.pdfBookId.isEmpty) {
        throw ArgumentError('PDF Book ID cannot be empty');
      }

      if (bookmark.pageNumber < 0) {
        throw ArgumentError('Page number must be non-negative');
      }

      await _storageRepository.saveBookmark(bookmark);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
