import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/domain/models/pdf_library/pdf_library.dart';
import 'package:drift/drift.dart';

class PdfLocalDataSource {
  final AppDatabase _db;

  PdfLocalDataSource(this._db);

  Future<List<PdfBook>> getAllBooks() async {
    final entities = await _db.managers.pdfBooks.get();
    return entities.map(_entityToDomain).toList();
  }

  Future<PdfBook?> getBookById(String id) async {
    final entity = await _db.managers.pdfBooks
        .filter((f) => f.id(id))
        .getSingleOrNull();

    if (entity == null) return null;
    return _entityToDomain(entity);
  }

  Future<void> insertBook(PdfBook book) async {
    await _db.managers.pdfBooks.create(
      (o) => o(
        id: book.id,
        title: book.title,
        author: Value(book.author),
        filePath: book.filePath,
        totalPages: book.totalPages,
        currentPage: Value(book.currentPage),
        lastRead: Value(book.lastRead),
        isFavorite: Value(book.isFavorite),
      ),
    );
  }

  Future<void> updateBook(PdfBook book) async {
    await _db.managers.pdfBooks
        .filter((f) => f.id(book.id))
        .update(
          (o) => o(
            title: Value(book.title),
            author: Value(book.author),
            filePath: Value(book.filePath),
            totalPages: Value(book.totalPages),
            currentPage: Value(book.currentPage),
            lastRead: Value(book.lastRead),
            isFavorite: Value(book.isFavorite),
          ),
        );
  }

  Future<void> deleteBook(String id) async {
    await _db.managers.pdfBooks.filter((f) => f.id(id)).delete();
  }

  PdfBook _entityToDomain(PdfBookEntity entity) {
    return PdfBook(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      filePath: entity.filePath,
      totalPages: entity.totalPages,
      currentPage: entity.currentPage,
      lastRead: entity.lastRead,
      isFavorite: entity.isFavorite,
    );
  }
}
