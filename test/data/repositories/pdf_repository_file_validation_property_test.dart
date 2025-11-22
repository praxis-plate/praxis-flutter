import 'dart:io';

import 'package:codium/data/repositories/pdf_repository.dart';
import 'package:codium/domain/datasources/i_bookmark_local_datasource.dart';
import 'package:codium/domain/datasources/i_pdf_local_datasource.dart';
import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'pdf_repository_file_validation_property_test.mocks.dart';

@GenerateMocks([IPdfLocalDataSource, IBookmarkLocalDataSource, Talker])
void main() {
  late PdfRepository repository;
  late MockIPdfLocalDataSource mockPdfDataSource;
  late MockIBookmarkLocalDataSource mockBookmarkDataSource;
  late MockTalker mockTalker;

  setUp(() {
    mockPdfDataSource = MockIPdfLocalDataSource();
    mockBookmarkDataSource = MockIBookmarkLocalDataSource();
    mockTalker = MockTalker();

    GetIt.I.registerSingleton<Talker>(mockTalker);

    repository = PdfRepository(mockPdfDataSource, mockBookmarkDataSource);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('PdfRepository - File Validation Property Tests', () {
    test(
      'Feature: codium-ai-enhancement, Property 35: Library File Validation - '
      'For any book in the library, if its file does not exist, '
      'the system should remove it from the database',
      () async {
        for (int i = 0; i < 100; i++) {
          final invalidBook = PdfBook(
            id: 'invalid-$i',
            title: 'Invalid Book $i',
            filePath: '/nonexistent/path/book-$i.pdf',
            totalPages: 10,
          );

          when(
            mockPdfDataSource.getAllBooks(),
          ).thenAnswer((_) async => [invalidBook]);

          when(
            mockPdfDataSource.deleteBook(invalidBook.id),
          ).thenAnswer((_) async => {});

          final books = await repository.getAllBooks();

          verify(mockPdfDataSource.deleteBook(invalidBook.id)).called(1);
          expect(books.length, equals(0));
        }
      },
    );

    test(
      'Feature: codium-ai-enhancement, Property 35: Library File Validation - '
      'For any book retrieval by ID, if its file does not exist, '
      'the system should remove it from the database and return null',
      () async {
        for (int i = 0; i < 100; i++) {
          final book = PdfBook(
            id: 'book-$i',
            title: 'Book $i',
            filePath: '/nonexistent/path/book-$i.pdf',
            totalPages: 10,
          );

          when(
            mockPdfDataSource.getBookById(book.id),
          ).thenAnswer((_) async => book);

          when(
            mockPdfDataSource.deleteBook(book.id),
          ).thenAnswer((_) async => {});

          final result = await repository.getBookById(book.id);

          verify(mockPdfDataSource.deleteBook(book.id)).called(1);
          expect(result, isNull);
        }
      },
    );

    test(
      'Feature: codium-ai-enhancement, Property 35: Library File Validation - '
      'For any book with existing file, the system should not remove it',
      () async {
        for (int i = 0; i < 100; i++) {
          final testFile = File('test_book_$i.pdf');
          await testFile.writeAsString('%PDF-1.4 test content');

          final book = PdfBook(
            id: 'book-$i',
            title: 'Book $i',
            filePath: testFile.path,
            totalPages: 10,
          );

          when(
            mockPdfDataSource.getBookById(book.id),
          ).thenAnswer((_) async => book);

          final result = await repository.getBookById(book.id);

          await testFile.delete();

          verifyNever(mockPdfDataSource.deleteBook(book.id));
          expect(result, isNotNull);
          expect(result?.id, equals(book.id));
        }
      },
    );
  });
}
