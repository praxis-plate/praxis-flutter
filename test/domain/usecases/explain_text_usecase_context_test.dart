import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/domain/repositories/ai_repository.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'explain_text_usecase_context_test.mocks.dart';

@GenerateMocks([IAiRepository, IStorageRepository, Talker])
void main() {
  late ExplainTextUseCase useCase;
  late MockIAiRepository mockAiRepository;
  late MockIStorageRepository mockStorageRepository;
  late MockTalker mockTalker;

  setUp(() {
    mockAiRepository = MockIAiRepository();
    mockStorageRepository = MockIStorageRepository();
    mockTalker = MockTalker();

    GetIt.I.registerSingleton<Talker>(mockTalker);

    useCase = ExplainTextUseCase(mockAiRepository, mockStorageRepository);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('ExplainTextUseCase - Context Capture Tests', () {
    test('should capture page number in explanation metadata', () async {
      const selectedText = 'polymorphism';
      const context = 'Object-oriented programming concepts';
      const pdfBookId = 'book-123';
      const pageNumber = 42;
      const explanationText = 'Polymorphism is a core concept in OOP...';

      when(
        mockAiRepository.explainText(text: selectedText, context: context),
      ).thenAnswer((_) async => explanationText);

      when(
        mockAiRepository.searchWeb(selectedText),
      ).thenAnswer((_) async => <SearchSource>[]);

      when(
        mockStorageRepository.saveExplanation(any),
      ).thenAnswer((_) async => {});

      final result = await useCase(
        selectedText: selectedText,
        context: context,
        pdfBookId: pdfBookId,
        pageNumber: pageNumber,
      );

      expect(result.pageNumber, equals(pageNumber));
      expect(result.pdfBookId, equals(pdfBookId));
      expect(result.selectedText, equals(selectedText));
      expect(result.explanation, equals(explanationText));

      verify(mockStorageRepository.saveExplanation(any)).called(1);
    });

    test('should preserve page context across multiple explanations', () async {
      final testCases = [
        {'text': 'inheritance', 'page': 10},
        {'text': 'encapsulation', 'page': 15},
        {'text': 'abstraction', 'page': 20},
      ];

      when(
        mockAiRepository.explainText(
          text: anyNamed('text'),
          context: anyNamed('context'),
        ),
      ).thenAnswer((_) async => 'Explanation text');

      when(
        mockAiRepository.searchWeb(any),
      ).thenAnswer((_) async => <SearchSource>[]);

      when(
        mockStorageRepository.saveExplanation(any),
      ).thenAnswer((_) async => {});

      for (final testCase in testCases) {
        final result = await useCase(
          selectedText: testCase['text'] as String,
          context: 'Context',
          pdfBookId: 'book-123',
          pageNumber: testCase['page'] as int,
        );

        expect(result.pageNumber, equals(testCase['page']));
      }

      verify(
        mockStorageRepository.saveExplanation(any),
      ).called(testCases.length);
    });

    test('should include page number even when web search fails', () async {
      const selectedText = 'recursion';
      const context = 'Algorithm concepts';
      const pdfBookId = 'book-456';
      const pageNumber = 99;

      when(
        mockAiRepository.explainText(text: selectedText, context: context),
      ).thenAnswer((_) async => 'Recursion explanation');

      when(
        mockAiRepository.searchWeb(selectedText),
      ).thenThrow(Exception('Network error'));

      when(
        mockStorageRepository.saveExplanation(any),
      ).thenAnswer((_) async => {});

      final result = await useCase(
        selectedText: selectedText,
        context: context,
        pdfBookId: pdfBookId,
        pageNumber: pageNumber,
      );

      expect(result.pageNumber, equals(pageNumber));
      expect(result.sources, isEmpty);
    });

    test('should create explanation with correct metadata structure', () async {
      const selectedText = 'closure';
      const context = 'Functional programming';
      const pdfBookId = 'book-789';
      const pageNumber = 5;

      when(
        mockAiRepository.explainText(text: selectedText, context: context),
      ).thenAnswer((_) async => 'Closure explanation');

      when(mockAiRepository.searchWeb(selectedText)).thenAnswer(
        (_) async => [
          const SearchSource(
            title: 'Closures in JavaScript',
            snippet: 'A closure is a function...',
            url: 'https://example.com/closures',
          ),
        ],
      );

      when(
        mockStorageRepository.saveExplanation(any),
      ).thenAnswer((_) async => {});

      final result = await useCase(
        selectedText: selectedText,
        context: context,
        pdfBookId: pdfBookId,
        pageNumber: pageNumber,
      );

      expect(result.id, isNotEmpty);
      expect(result.pdfBookId, equals(pdfBookId));
      expect(result.pageNumber, equals(pageNumber));
      expect(result.selectedText, equals(selectedText));
      expect(result.explanation, isNotEmpty);
      expect(result.sources, isNotEmpty);
      expect(result.createdAt, isNotNull);
    });

    test('should handle page number zero correctly', () async {
      const pageNumber = 0;

      when(
        mockAiRepository.explainText(
          text: anyNamed('text'),
          context: anyNamed('context'),
        ),
      ).thenAnswer((_) async => 'Explanation');

      when(
        mockAiRepository.searchWeb(any),
      ).thenAnswer((_) async => <SearchSource>[]);

      when(
        mockStorageRepository.saveExplanation(any),
      ).thenAnswer((_) async => {});

      final result = await useCase(
        selectedText: 'test',
        context: 'context',
        pdfBookId: 'book-id',
        pageNumber: pageNumber,
      );

      expect(result.pageNumber, equals(0));
    });

    test('should handle large page numbers correctly', () async {
      const pageNumber = 9999;

      when(
        mockAiRepository.explainText(
          text: anyNamed('text'),
          context: anyNamed('context'),
        ),
      ).thenAnswer((_) async => 'Explanation');

      when(
        mockAiRepository.searchWeb(any),
      ).thenAnswer((_) async => <SearchSource>[]);

      when(
        mockStorageRepository.saveExplanation(any),
      ).thenAnswer((_) async => {});

      final result = await useCase(
        selectedText: 'test',
        context: 'context',
        pdfBookId: 'book-id',
        pageNumber: pageNumber,
      );

      expect(result.pageNumber, equals(9999));
    });

    test('should save explanation with page context to storage', () async {
      const selectedText = 'interface';
      const pageNumber = 25;
      const pdfBookId = 'book-abc';

      when(
        mockAiRepository.explainText(
          text: anyNamed('text'),
          context: anyNamed('context'),
        ),
      ).thenAnswer((_) async => 'Interface explanation');

      when(
        mockAiRepository.searchWeb(any),
      ).thenAnswer((_) async => <SearchSource>[]);

      when(
        mockStorageRepository.saveExplanation(any),
      ).thenAnswer((_) async => {});

      await useCase(
        selectedText: selectedText,
        context: 'context',
        pdfBookId: pdfBookId,
        pageNumber: pageNumber,
      );

      final captured =
          verify(
                mockStorageRepository.saveExplanation(captureAny),
              ).captured.single
              as Explanation;

      expect(captured.pageNumber, equals(pageNumber));
      expect(captured.pdfBookId, equals(pdfBookId));
      expect(captured.selectedText, equals(selectedText));
    });
  });
}
