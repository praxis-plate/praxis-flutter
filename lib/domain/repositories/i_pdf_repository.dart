import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/pdf_book/create_pdf_book_model.dart';
import 'package:codium/domain/models/pdf_book/pdf_book_model.dart';
import 'package:codium/domain/models/pdf_book/update_pdf_book_model.dart';

abstract interface class IPdfRepository {
  Future<Result<List<PdfBookModel>>> getAllBooks();
  Future<Result<PdfBookModel?>> getBookById(int id);
  Future<Result<void>> create(CreatePdfBookModel model);
  Future<Result<void>> update(UpdatePdfBookModel model);
  Future<Result<void>> updateReadingProgress(int bookId, int page);
  Future<Result<void>> delete(int bookId);
}
