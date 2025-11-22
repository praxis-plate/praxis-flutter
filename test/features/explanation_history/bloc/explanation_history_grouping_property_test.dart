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

  group('Property 24: History Grouping', () {
    test(
      'Feature: codium-ai-enhancement, Property 24: History Grouping - For any explanation history view, explanations should be grouped by their associated PDF',
      () async {
        for (int iteration = 0; iteration < 100; iteration++) {
          final numBooks = random.nextInt(5) + 1;
          final bookIds = List.generate(numBooks, (i) => 'book_${uuid.v4()}');

          for (final bookId in bookIds) {
            await database.managers.pdfBooks.create(
              (o) => o(
                id: bookId,
                title: 'Book $bookId',
                filePath: '/path/to/$bookId.pdf',
                totalPages: 100,
              ),
            );
          }

          final numExplanations = random.nextInt(20) + 5;
          final explanations = <Explanation>[];

          for (int i = 0; i < numExplanations; i++) {
            final bookId = bookIds[random.nextInt(bookIds.length)];
            final explanation = Explanation(
              id: uuid.v4(),
              pdfBookId: bookId,
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

          final state = bloc.state;
          expect(state, isA<ExplanationHistoryLoadedState>());

          final loadedState = state as ExplanationHistoryLoadedState;
          final grouped = loadedState.groupedExplanations;

          for (final bookId in bookIds) {
            final expectedExplanations = explanations
                .where((e) => e.pdfBookId == bookId)
                .toList();

            if (expectedExplanations.isNotEmpty) {
              expect(
                grouped.containsKey(bookId),
                true,
                reason: 'Book $bookId should be in grouped explanations',
              );

              final groupedForBook = grouped[bookId]!;
              expect(
                groupedForBook.length,
                expectedExplanations.length,
                reason: 'Number of explanations for book $bookId should match',
              );

              for (final explanation in expectedExplanations) {
                expect(
                  groupedForBook.any((e) => e.id == explanation.id),
                  true,
                  reason: 'Explanation ${explanation.id} should be in group',
                );
              }

              for (int i = 0; i < groupedForBook.length - 1; i++) {
                expect(
                  groupedForBook[i].createdAt.isAfter(
                    groupedForBook[i + 1].createdAt,
                  ),
                  true,
                  reason:
                      'Explanations should be sorted by createdAt descending',
                );
              }
            }
          }

          for (final bookId in bookIds) {
            await database.managers.pdfBooks
                .filter((f) => f.id(bookId))
                .delete();
          }
        }
      },
    );
  });
}
