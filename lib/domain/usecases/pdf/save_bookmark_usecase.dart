import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/bookmark/create_bookmark_model.dart';
import 'package:codium/domain/repositories/i_bookmark_repository.dart';

class SaveBookmarkUseCase {
  final IBookmarkRepository _bookmarkRepository;

  SaveBookmarkUseCase(this._bookmarkRepository);

  Future<Result<void>> call(CreateBookmarkModel bookmark) async {
    return await _bookmarkRepository.saveBookmark(bookmark);
  }
}
