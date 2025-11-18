import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/models/pdf_reader/bookmark.dart';

abstract interface class IStorageRepository {
  Future<List<Bookmark>> getBookmarksByPdfId(String pdfId);
  Future<void> saveBookmark(Bookmark bookmark);
  Future<void> deleteBookmark(String bookmarkId);

  Future<List<Explanation>> getExplanationsByPdfId(String pdfId);
  Future<void> saveExplanation(Explanation explanation);
  Future<void> deleteExplanation(String explanationId);
  Future<List<Explanation>> searchExplanations(String query);
}
