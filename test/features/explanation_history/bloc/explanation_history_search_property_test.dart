import 'dart:math';

import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/data/datasources/local/bookmark_local_datasource.dart';
import 'package:codium/data/datasources/local/explanation_local_datasource.dart';
import 'package:codium/data/repositories/storage_repository.dart';
import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/explanation_history/bloc/explanation_history_bloc.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase database;
  late IStorageRepository repository;
  late ExplanationHistoryBloc bloc;
  final random = Random(42);
  const uuid = Uuid();

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    final bookmarkDataSource = BookmarkLocalDataSource(database);
    final explanationDataSource = ExplanationLocalDataSource(database);
    repository = StorageRepository(bookmarkDataSource, explanationDataSource);

    final getHistoryUseCase = GetExplanationHistoryUseCase(repository);
    final searchHistoryUseCase = SearchExplanationHistoryUseCase(repository);
    final deleteUseCase = DeleteExplanationUseCase(repository);

    bloc = ExplanationHistoryBloc(
      getExplanationHistoryUseCase: getHistoryUseCase,
      searchExplanationHistoryUseCase: searchHistoryUseCase,
      deleteExplanationUseCase: deleteUseCase,
    );
  });

  tearDown(() async {
    await bloc.close();
    await database.close();
  });

  group('Property 27: History Search Filter', () {
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
      'Feature: codium-ai-enhancement, Property 27: History Search Filter - For any search query in history, the results should only include explanations where the text content matches the query',
      () async {
        for (int iteration = 0; iteration < 100; iteration++) {
          final searchTerms = [
            'polymorphism',
            'inheritance',
            'encapsulation',
            'abstraction',
            'interface',
          ];

          final numExplanations = random.nextInt(20) + 10;
          final explanations = <Explanation>[];

          for (int i = 0; i < numExplanations; i++) {
            final selectedText =
                searchTerms[random.nextInt(searchTerms.length)];
            final explanationText =
                'This is an explanation about ${searchTerms[random.nextInt(searchTerms.length)]}';

            final explanation = Explanation(
              id: uuid.v4(),
              pdfBookId: 'book1',
              pageNumber: random.nextInt(100) + 1,
              selectedText: selectedText,
              explanation: explanationText,
              createdAt: DateTime.now().subtract(Duration(minutes: i)),
            );
            explanations.add(explanation);
            await repository.saveExplanation(explanation);
          }

          bloc.add(LoadHistoryEvent());
          await Future.delayed(const Duration(milliseconds: 100));

          final searchQuery = searchTerms[random.nextInt(searchTerms.length)];
          bloc.add(SearchHistoryEvent(searchQuery));
          await Future.delayed(const Duration(milliseconds: 100));

          final state = bloc.state;
          expect(state, isA<ExplanationHistoryLoadedState>());

          final loadedState = state as ExplanationHistoryLoadedState;
          final grouped = loadedState.groupedExplanations;

          final allFilteredExplanations = <Explanation>[];
          for (final group in grouped.values) {
            allFilteredExplanations.addAll(group);
          }

          for (final explanation in allFilteredExplanations) {
            final matchesSelectedText = explanation.selectedText
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
            final matchesExplanation = explanation.explanation
                .toLowerCase()
                .contains(searchQuery.toLowerCase());

            expect(
              matchesSelectedText || matchesExplanation,
              true,
              reason:
                  'Explanation ${explanation.id} should match query "$searchQuery"',
            );
          }

          final expectedMatches = explanations.where((e) {
            final matchesSelectedText = e.selectedText.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesExplanation = e.explanation.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            return matchesSelectedText || matchesExplanation;
          }).toList();

          expect(
            allFilteredExplanations.length,
            expectedMatches.length,
            reason:
                'Number of filtered explanations should match expected matches',
          );

          for (final explanation in explanations) {
            await database.managers.explanations
                .filter((f) => f.id(explanation.id))
                .delete();
          }
        }
      },
    );

    test(
      'Feature: codium-ai-enhancement, Property 27: History Search Filter - Empty query should return all explanations',
      () async {
        for (int iteration = 0; iteration < 100; iteration++) {
          final numExplanations = random.nextInt(20) + 5;
          final explanations = <Explanation>[];

          for (int i = 0; i < numExplanations; i++) {
            final explanation = Explanation(
              id: uuid.v4(),
              pdfBookId: 'book1',
              pageNumber: random.nextInt(100) + 1,
              selectedText: 'text_$i',
              explanation: 'explanation_$i',
              createdAt: DateTime.now().subtract(Duration(minutes: i)),
            );
            explanations.add(explanation);
            await repository.saveExplanation(explanation);
          }

          bloc.add(LoadHistoryEvent());
          await Future.delayed(const Duration(milliseconds: 100));

          bloc.add(const SearchHistoryEvent(''));
          await Future.delayed(const Duration(milliseconds: 100));

          final state = bloc.state;
          expect(state, isA<ExplanationHistoryLoadedState>());

          final loadedState = state as ExplanationHistoryLoadedState;
          final grouped = loadedState.groupedExplanations;

          final allExplanations = <Explanation>[];
          for (final group in grouped.values) {
            allExplanations.addAll(group);
          }

          expect(
            allExplanations.length,
            explanations.length,
            reason: 'Empty query should return all explanations',
          );

          for (final explanation in explanations) {
            await database.managers.explanations
                .filter((f) => f.id(explanation.id))
                .delete();
          }
        }
      },
    );
  });
}
