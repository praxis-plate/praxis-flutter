import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/bookmark_entity_extension.dart';
import 'package:codium/domain/datasources/i_bookmark_local_datasource.dart';
import 'package:codium/domain/models/bookmark/bookmark_model.dart';
import 'package:codium/domain/models/bookmark/create_bookmark_model.dart';
import 'package:codium/domain/repositories/i_bookmark_repository.dart';

class BookmarkRepository implements IBookmarkRepository {
  final IBookmarkLocalDataSource _localDataSource;

  const BookmarkRepository(this._localDataSource);

  @override
  Future<Result<List<BookmarkModel>>> getBookmarksByPdfId(int pdfBookId) async {
    try {
      final entities = await _localDataSource.getBookmarksByPdfId(pdfBookId);
      final bookmarks = entities.map((e) => e.toDomain()).toList();
      return Success(bookmarks);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> saveBookmark(CreateBookmarkModel bookmark) async {
    try {
      await _localDataSource.insertBookmark(bookmark.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> deleteBookmark(int bookmarkId) async {
    try {
      await _localDataSource.deleteBookmark(bookmarkId);
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
