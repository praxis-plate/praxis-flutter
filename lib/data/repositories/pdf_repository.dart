import 'dart:io';

import 'package:codium/core/exceptions/exceptions.dart';
import 'package:codium/domain/datasources/i_bookmark_local_datasource.dart';
import 'package:codium/domain/datasources/i_pdf_local_datasource.dart';
import 'package:codium/domain/models/pdf_library/pdf_library.dart';
import 'package:codium/domain/models/pdf_reader/pdf_reader.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:pdfx/pdfx.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PdfRepository implements IPdfRepository {
  final IPdfLocalDataSource _pdfDataSource;
  final IBookmarkLocalDataSource _bookmarkDataSource;

  PdfRepository(this._pdfDataSource, this._bookmarkDataSource);

  @override
  Future<List<PdfBook>> getAllBooks() async {
    try {
      final allBooks = await _pdfDataSource.getAllBooks();
      final validBooks = <PdfBook>[];

      for (final book in allBooks) {
        final file = File(book.filePath);
        if (await file.exists()) {
          validBooks.add(book);
        } else {
          GetIt.I<Talker>().warning(
            'Book file not found, removing from library: ${book.title} (${book.filePath})',
          );
          await _pdfDataSource.deleteBook(book.id);
        }
      }

      return validBooks;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get all books: $e');
    }
  }

  @override
  Future<PdfBook?> getBookById(String id) async {
    try {
      final book = await _pdfDataSource.getBookById(id);
      if (book == null) return null;

      final file = File(book.filePath);
      if (!await file.exists()) {
        GetIt.I<Talker>().warning(
          'Book file not found, removing from library: ${book.title} (${book.filePath})',
        );
        await _pdfDataSource.deleteBook(book.id);
        return null;
      }

      return book;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get book by id: $e');
    }
  }

  @override
  Future<void> importPdf(String filePath) async {
    try {
      final document = await PdfDocument.openFile(filePath);
      final totalPages = document.pagesCount;
      await document.close();

      final book = PdfBook(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _extractTitleFromPath(filePath),
        filePath: filePath,
        totalPages: totalPages,
      );
      await _pdfDataSource.insertBook(book);
    } on PdfException {
      throw const FileSystemError.corrupted();
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);

      if (e is PdfInvalidFormatException || e is PdfRenderException) {
        throw const FileSystemError.corrupted();
      }

      final errorString = e.toString();
      if (errorString.contains('Invalid PDF format') ||
          errorString.contains('RENDER_ERROR')) {
        throw const FileSystemError.corrupted();
      }
      throw Exception('Failed to import PDF: $e');
    }
  }

  @override
  Future<void> updateBook(PdfBook book) async {
    try {
      await _pdfDataSource.updateBook(book);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to update book: $e');
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
