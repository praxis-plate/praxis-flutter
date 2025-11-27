import 'package:codium/data/database/tables/pdf_book.dart';
import 'package:drift/drift.dart';

@DataClassName('BookmarkEntity')
class Bookmark extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pdfBookId =>
      integer().references(PdfBook, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageNumber => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
