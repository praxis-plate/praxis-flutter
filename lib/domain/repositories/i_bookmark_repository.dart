import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/bookmark/bookmark_model.dart';
import 'package:codium/domain/models/bookmark/create_bookmark_model.dart';

abstract interface class IBookmarkRepository {
  Future<Result<List<BookmarkModel>>> getBookmarksByPdfId(int pdfBookId);
  Future<Result<void>> saveBookmark(CreateBookmarkModel bookmark);
  Future<Result<void>> deleteBookmark(int bookmarkId);
}
