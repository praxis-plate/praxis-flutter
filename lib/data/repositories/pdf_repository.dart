import 'dart:io';

import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/pdf_book_entity_extension.dart';
import 'package:codium/domain/datasources/i_pdf_local_datasource.dart';
import 'package:codium/domain/models/pdf_book/create_pdf_book_model.dart';
import 'package:codium/domain/models/pdf_book/pdf_book_model.dart';
import 'package:codium/domain/models/pdf_book/update_pdf_book_model.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PdfRepository implements IPdfRepository {
  final IPdfLocalDataSource _pdfDataSource;

  const PdfRepository(this._pdfDataSource);

  @override
  Future<Result<List<PdfBookModel>>> getAllBooks() async {
    try {
      final entities = await _pdfDataSource.getAllBooks();
      final validBooks = <PdfBookModel>[];

      for (final entity in entities) {
        final file = File(entity.filePath);
        if (await file.exists()) {
          validBooks.add(entity.toDomain());
        } else {
          GetIt.I<Talker>().warning(
            'Book file not found, removing from library: ${entity.title} (${entity.filePath})',
          );
          await _pdfDataSource.deleteBook(entity.id);
        }
      }

      return Success(validBooks);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<PdfBookModel?>> getBookById(int id) async {
    try {
      final entity = await _pdfDataSource.getBookById(id);
      if (entity == null) return const Success(null);

      final file = File(entity.filePath);
      if (!await file.exists()) {
        GetIt.I<Talker>().warning(
          'Book file not found, removing from library: ${entity.title} (${entity.filePath})',
        );
        await _pdfDataSource.deleteBook(entity.id);
        return const Success(null);
      }

      return Success(entity.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> create(CreatePdfBookModel model) async {
    try {
      await _pdfDataSource.insertBook(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> update(UpdatePdfBookModel model) async {
    try {
      await _pdfDataSource.updateBook(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> updateReadingProgress(int bookId, int page) async {
    try {
      final entity = await _pdfDataSource.getBookById(bookId);
      if (entity == null) {
        return const Failure(
          AppFailure(code: AppErrorCode.apiNotFound, message: ''),
        );
      }

      final updateModel = UpdatePdfBookModel(
        id: bookId,
        currentPage: page,
        lastRead: DateTime.now(),
      );

      await _pdfDataSource.updateBook(updateModel.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> delete(int bookId) async {
    try {
      await _pdfDataSource.deleteBook(bookId);
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
