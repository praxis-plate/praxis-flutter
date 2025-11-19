import 'package:codium/data/datasources/local/bookmark_local_datasource.dart';
import 'package:codium/data/datasources/local/explanation_local_datasource.dart';
import 'package:codium/domain/models/ai_explanation/ai_explanation.dart';
import 'package:codium/domain/models/pdf_reader/pdf_reader.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class StorageRepositoryImpl implements IStorageRepository {
  final BookmarkLocalDataSource _bookmarkDataSource;
  final ExplanationLocalDataSource _explanationDataSource;

  StorageRepositoryImpl(this._bookmarkDataSource, this._explanationDataSource);

  @override
  Future<List<Bookmark>> getBookmarksByPdfId(String pdfId) async {
    try {
      return await _bookmarkDataSource.getBookmarksByPdfId(pdfId);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get bookmarks by PDF ID: $e');
    }
  }

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {
    try {
      await _bookmarkDataSource.insertBookmark(bookmark);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to save bookmark: $e');
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

  @override
  Future<List<Explanation>> getAllExplanations() async {
    try {
      return await _explanationDataSource.getAllExplanations();
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get all explanations: $e');
    }
  }

  @override
  Future<List<Explanation>> getExplanationsByPdfId(String pdfId) async {
    try {
      return await _explanationDataSource.getExplanationsByPdfId(pdfId);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to get explanations by PDF ID: $e');
    }
  }

  @override
  Future<void> saveExplanation(Explanation explanation) async {
    try {
      await _explanationDataSource.insertExplanation(explanation);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to save explanation: $e');
    }
  }

  @override
  Future<void> deleteExplanation(String explanationId) async {
    try {
      await _explanationDataSource.deleteExplanation(explanationId);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to delete explanation: $e');
    }
  }

  @override
  Future<List<Explanation>> searchExplanations(String query) async {
    try {
      return await _explanationDataSource.searchExplanations(query);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw Exception('Failed to search explanations: $e');
    }
  }
}
