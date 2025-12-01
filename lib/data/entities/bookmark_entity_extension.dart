import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/bookmark/bookmark_model.dart';
import 'package:codium/domain/models/bookmark/create_bookmark_model.dart';
import 'package:codium/domain/models/bookmark/update_bookmark_model.dart';
import 'package:drift/drift.dart';

extension BookmarkEntityExtension on BookmarkEntity {
  BookmarkModel toDomain() {
    return BookmarkModel(
      id: id,
      pdfBookId: pdfBookId,
      pageNumber: pageNumber,
      note: note,
      createdAt: createdAt,
    );
  }
}

extension CreateBookmarkModelExtension on CreateBookmarkModel {
  BookmarkCompanion toCompanion() {
    return BookmarkCompanion.insert(
      pdfBookId: pdfBookId,
      pageNumber: pageNumber,
      note: Value(note),
      createdAt: DateTime.now(),
    );
  }
}

extension UpdateBookmarkModelExtension on UpdateBookmarkModel {
  BookmarkCompanion toCompanion() {
    return BookmarkCompanion(
      id: Value(id),
      pageNumber: pageNumber != null
          ? Value(pageNumber!)
          : const Value.absent(),
      note: note != null ? Value(note) : const Value.absent(),
    );
  }
}
