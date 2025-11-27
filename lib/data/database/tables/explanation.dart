import 'package:codium/data/database/tables/pdf_book.dart';
import 'package:drift/drift.dart';

@DataClassName('ExplanationEntity')
class Explanation extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pdfBookId =>
      integer().references(PdfBook, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageNumber => integer()();
  TextColumn get selectedText => text()();
  TextColumn get explanation => text()();
  TextColumn get sources => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
