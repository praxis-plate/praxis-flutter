import 'dart:math';

import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/data/datasources/local/bookmark_local_datasource.dart';
import 'package:codium/data/datasources/local/explanation_local_datasource.dart';
import 'package:codium/data/repositories/storage_repository_impl.dart';
import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase database;
  late IStorageRepository repository;
  final random = Random(42);
  const uuid = Uuid();

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    final bookmarkDataSource = BookmarkLocalDataSource(database);
    final explanationDataSource = ExplanationLocalDataSource(database);
    repository = StorageRepositoryImpl(
      bookmarkDataSource,
      explanationDataSource,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('Property 23: Explanation History Persistence', () {
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

    test(
      'Feature: codium-ai-enhancement, Property 23: Explanation History Persistence - For any AI-generated explanation, the system should save the text-explanation pair with timestamp to the database',
      () async {
        for (int i = 0; i < 100; i++) {
          final explanation = _generateRandomExplanation(random, uuid);

          await repository.saveExplanation(explanation);

          final allExplanations = await repository.getAllExplanations();
          final saved = allExplanations.firstWhere(
            (e) => e.id == explanation.id,
            orElse: () => throw Exception('Explanation not found'),
          );

          expect(saved.id, explanation.id);
          expect(saved.pdfBookId, explanation.pdfBookId);
          expect(saved.pageNumber, explanation.pageNumber);
          expect(saved.selectedText, explanation.selectedText);
          expect(saved.explanation, explanation.explanation);
          expect(saved.sources.length, explanation.sources.length);
          expect(
            saved.createdAt.difference(explanation.createdAt).inSeconds,
            lessThan(1),
          );

          await database.managers.explanations
              .filter((f) => f.id(explanation.id))
              .delete();
        }
      },
    );
  });
}

Explanation _generateRandomExplanation(Random random, Uuid uuid) {
  final selectedTexts = [
    'polymorphism',
    'inheritance',
    'encapsulation',
    'abstraction',
    'interface',
    'class',
    'object',
    'method',
    'variable',
    'function',
  ];

  final explanationTexts = [
    'This is a fundamental concept in object-oriented programming',
    'It allows code reuse and hierarchical relationships',
    'It helps in hiding implementation details',
    'It provides a way to achieve loose coupling',
    'It defines a contract for classes to implement',
  ];

  final numSources = random.nextInt(4);
  final sources = List.generate(
    numSources,
    (index) => SearchSource(
      title: 'Source ${index + 1}',
      snippet: 'Snippet for source ${index + 1}',
      url: 'https://example.com/${index + 1}',
    ),
  );

  return Explanation(
    id: uuid.v4(),
    pdfBookId: 'book1',
    pageNumber: random.nextInt(100) + 1,
    selectedText: selectedTexts[random.nextInt(selectedTexts.length)],
    explanation: explanationTexts[random.nextInt(explanationTexts.length)],
    sources: sources,
    createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
  );
}
