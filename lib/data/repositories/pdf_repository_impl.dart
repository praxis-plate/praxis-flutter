import 'package:codium/data/datasources/local/bookmark_local_datasource.dart';
import 'package:codium/data/datasources/local/pdf_local_datasource.dart';
import 'package:codium/domain/models/pdf_library/pdf_library.dart';
import 'package:codium/domain/models/pdf_reader/pdf_reader.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PdfRepositoryImpl implements IPdfRepository {
  final PdfLocalDataSource _pdfDataSource;
  final BookmarkLocalDataSource _bookmarkDataSource;

  PdfRepositoryImpl(this._pdfDataSource, this._bookmarkDataSource);

  @override
  Future<List<PdfBook>> getAllBooks() async {
    try {
      return await _pdfDataSource.getAllBooks();
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get all books: $e');
    }
  }

  @override
  Future<PdfBook?> getBookById(String id) async {
    try {
      return await _pdfDataSource.getBookById(id);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get book by id: $e');
    }
  }

  @override
  Future<void> importPdf(String filePath) async {
    try {
      final book = PdfBook(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _extractTitleFromPath(filePath),
        filePath: filePath,
        totalPages: 0,
      );
      await _pdfDataSource.insertBook(book);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to import PDF: $e');
    }
  }

  @override
  Future<void> updateReadingProgress(String bookId, int page) async {
    try {
      final book = await _pdfDataSource.getBookById(bookId);
      if (book == null) {
        throw Exception('Book not found');
      }

      final updatedBook = book.copyWith(
        currentPage: page,
        lastRead: DateTime.now(),
      );

      await _pdfDataSource.updateBook(updatedBook);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to update reading progress: $e');
    }
  }

  @override
  Future<void> deleteBook(String bookId) async {
    try {
      await _pdfDataSource.deleteBook(bookId);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to delete book: $e');
    }
  }

  @override
  Future<List<Bookmark>> getBookmarks(String bookId) async {
    try {
      return await _bookmarkDataSource.getBookmarksByPdfId(bookId);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get bookmarks: $e');
    }
  }

  @override
  Future<void> addBookmark(Bookmark bookmark) async {
    try {
      await _bookmarkDataSource.insertBookmark(bookmark);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to add bookmark: $e');
    }
  }

  @override
  Future<void> deleteBookmark(String bookmarkId) async {
    try {
      await _bookmarkDataSource.deleteBookmark(bookmarkId);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to delete bookmark: $e');
    }
  }

  String _extractTitleFromPath(String filePath) {
    final fileName = filePath.split('/').last;
    return fileName.replaceAll('.pdf', '').replaceAll('_', ' ');
  }
}
