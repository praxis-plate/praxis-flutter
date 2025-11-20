import 'package:drift/drift.dart';

@DataClassName('PdfBookEntity')
class PdfBooks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get filePath => text()();
  IntColumn get totalPages => integer()();
  IntColumn get currentPage => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastRead => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BookmarkEntity')
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get pdfBookId =>
      text().references(PdfBooks, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageNumber => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExplanationEntity')
class Explanations extends Table {
  TextColumn get id => text()();
  TextColumn get pdfBookId =>
      text().references(PdfBooks, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageNumber => integer()();
  TextColumn get selectedText => text()();
  TextColumn get explanation => text()();
  TextColumn get sources => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserEntity')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
