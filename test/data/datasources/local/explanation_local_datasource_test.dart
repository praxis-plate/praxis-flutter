import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/data/datasources/local/explanation_local_datasource.dart';
import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late ExplanationLocalDataSource dataSource;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = ExplanationLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('ExplanationLocalDataSource', () {
    setUp(() async {
      await database.managers.pdfBooks.create(
        (o) => o(
          id: 'book1',
          title: 'Test Book',
          filePath: '/path/to/book.pdf',
          totalPages: 100,
        ),
      );
    });

    test('should insert and retrieve an explanation', () async {
      final now = DateTime.now();
      final explanation = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        sources: const [],
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation);

      final retrieved = await dataSource.getExplanationById('explanation1');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, explanation.id);
      expect(retrieved.pdfBookId, explanation.pdfBookId);
      expect(retrieved.pageNumber, explanation.pageNumber);
      expect(retrieved.selectedText, explanation.selectedText);
      expect(retrieved.explanation, explanation.explanation);
      expect(retrieved.sources, isEmpty);
      expect(retrieved.createdAt.difference(now).inSeconds, lessThan(1));
    });

    test('should insert and retrieve explanation with sources', () async {
      final now = DateTime.now();
      final sources = [
        const SearchSource(
          title: 'Source 1',
          snippet: 'Snippet 1',
          url: 'https://example.com/1',
        ),
        const SearchSource(
          title: 'Source 2',
          snippet: 'Snippet 2',
          url: 'https://example.com/2',
        ),
      ];

      final explanation = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        sources: sources,
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation);

      final retrieved = await dataSource.getExplanationById('explanation1');

      expect(retrieved!.sources.length, 2);
      expect(retrieved.sources[0].title, 'Source 1');
      expect(retrieved.sources[0].snippet, 'Snippet 1');
      expect(retrieved.sources[0].url, 'https://example.com/1');
      expect(retrieved.sources[1].title, 'Source 2');
      expect(retrieved.sources[1].snippet, 'Snippet 2');
      expect(retrieved.sources[1].url, 'https://example.com/2');
    });

    test('should get explanations by PDF book id', () async {
      final now = DateTime.now();
      final explanation1 = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        createdAt: now,
      );

      final explanation2 = Explanation(
        id: 'explanation2',
        pdfBookId: 'book1',
        pageNumber: 20,
        selectedText: 'inheritance',
        explanation: 'Inheritance is...',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation1);
      await dataSource.insertExplanation(explanation2);

      final explanations = await dataSource.getExplanationsByPdfId('book1');

      expect(explanations.length, 2);
      expect(explanations.any((e) => e.id == 'explanation1'), true);
      expect(explanations.any((e) => e.id == 'explanation2'), true);
    });

    test('should get all explanations', () async {
      final now = DateTime.now();
      final explanation1 = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        createdAt: now,
      );

      final explanation2 = Explanation(
        id: 'explanation2',
        pdfBookId: 'book1',
        pageNumber: 20,
        selectedText: 'inheritance',
        explanation: 'Inheritance is...',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation1);
      await dataSource.insertExplanation(explanation2);

      final explanations = await dataSource.getAllExplanations();

      expect(explanations.length, 2);
    });

    test('should search explanations by selected text', () async {
      final now = DateTime.now();
      final explanation1 = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        createdAt: now,
      );

      final explanation2 = Explanation(
        id: 'explanation2',
        pdfBookId: 'book1',
        pageNumber: 20,
        selectedText: 'inheritance',
        explanation: 'Inheritance is...',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation1);
      await dataSource.insertExplanation(explanation2);

      final results = await dataSource.searchExplanations('poly');

      expect(results.length, 1);
      expect(results.first.selectedText, 'polymorphism');
    });

    test('should search explanations by explanation text', () async {
      final now = DateTime.now();
      final explanation1 = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'term1',
        explanation: 'This is about polymorphism',
        createdAt: now,
      );

      final explanation2 = Explanation(
        id: 'explanation2',
        pdfBookId: 'book1',
        pageNumber: 20,
        selectedText: 'term2',
        explanation: 'This is about inheritance',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation1);
      await dataSource.insertExplanation(explanation2);

      final results = await dataSource.searchExplanations('polymorphism');

      expect(results.length, 1);
      expect(results.first.id, 'explanation1');
    });

    test('should search case-insensitively', () async {
      final now = DateTime.now();
      final explanation = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'Polymorphism',
        explanation: 'Polymorphism is...',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation);

      final results = await dataSource.searchExplanations('POLY');

      expect(results.length, 1);
    });

    test('should update an explanation', () async {
      final now = DateTime.now();
      final explanation = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation);

      final updatedExplanation = explanation.copyWith(
        explanation: 'Updated explanation',
      );

      await dataSource.updateExplanation(updatedExplanation);

      final retrieved = await dataSource.getExplanationById('explanation1');

      expect(retrieved!.explanation, 'Updated explanation');
    });

    test('should delete an explanation', () async {
      final now = DateTime.now();
      final explanation = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation);
      await dataSource.deleteExplanation('explanation1');

      final retrieved = await dataSource.getExplanationById('explanation1');

      expect(retrieved, isNull);
    });

    test('should return null for non-existent explanation', () async {
      final retrieved = await dataSource.getExplanationById('nonexistent');

      expect(retrieved, isNull);
    });

    test('should return empty list for search with no matches', () async {
      final now = DateTime.now();
      final explanation = Explanation(
        id: 'explanation1',
        pdfBookId: 'book1',
        pageNumber: 10,
        selectedText: 'polymorphism',
        explanation: 'Polymorphism is...',
        createdAt: now,
      );

      await dataSource.insertExplanation(explanation);

      final results = await dataSource.searchExplanations('nonexistent');

      expect(results, isEmpty);
    });
  });
}
