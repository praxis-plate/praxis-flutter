import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_pdf_local_datasource.dart';

class PdfLocalDataSource implements IPdfLocalDataSource {
  final AppDatabase _db;

  PdfLocalDataSource(this._db);

  @override
  Future<List<PdfBookEntity>> getAllBooks() async {
    return await _db.managers.pdfBook.get();
  }

  @override
  Future<PdfBookEntity?> getBookById(int id) async {
    return await _db.managers.pdfBook.filter((f) => f.id(id)).getSingleOrNull();
  }

  @override
  Future<PdfBookEntity> insertBook(PdfBookEntity entry) async {
    return await _db.into(_db.pdfBook).insertReturning(entry);
  }

  @override
  Future<void> updateBook(PdfBookCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('PdfBook id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.pdfBook)..where((t) => t.id.equals(id))).write(entry);
  }

  @override
  Future<void> deleteBook(int id) async {
    await _db.managers.pdfBook.filter((f) => f.id(id)).delete();
  }
}
