import 'package:drift/drift.dart';

@DataClassName('PdfBookEntity')
class PdfBook extends Table {
  IntColumn get id => integer().autoIncrement()();
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
