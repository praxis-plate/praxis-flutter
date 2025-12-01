import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/pdf_book/create_pdf_book_model.dart';
import 'package:codium/domain/models/pdf_book/pdf_book_model.dart';
import 'package:codium/domain/models/pdf_book/update_pdf_book_model.dart';
import 'package:drift/drift.dart';

extension PdfBookEntityExtension on PdfBookEntity {
  PdfBookModel toDomain() {
    return PdfBookModel(
      id: id,
      title: title,
      author: author,
      filePath: filePath,
      totalPages: totalPages,
      currentPage: currentPage,
      lastRead: lastRead,
      isFavorite: isFavorite,
    );
  }
}

extension CreatePdfBookModelExtension on CreatePdfBookModel {
  PdfBookCompanion toCompanion() {
    return PdfBookCompanion.insert(
      title: title,
      author: Value(author),
      filePath: filePath,
      totalPages: totalPages,
    );
  }
}

extension UpdatePdfBookModelExtension on UpdatePdfBookModel {
  PdfBookCompanion toCompanion() {
    return PdfBookCompanion(
      id: Value(id),
      title: title != null ? Value(title!) : const Value.absent(),
      author: author != null ? Value(author) : const Value.absent(),
      currentPage: currentPage != null
          ? Value(currentPage!)
          : const Value.absent(),
      lastRead: lastRead != null ? Value(lastRead) : const Value.absent(),
      isFavorite: isFavorite != null
          ? Value(isFavorite!)
          : const Value.absent(),
    );
  }
}
