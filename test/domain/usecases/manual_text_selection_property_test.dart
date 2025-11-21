import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/domain/repositories/ai_repository.dart';
import 'package:codium/domain/repositories/storage_repository.dart';
import 'package:codium/domain/usecases/explain_text_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'manual_text_selection_property_test.mocks.dart';

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

  group('Property-Based Tests - Manual Text Selection Flow', () {
    test(
      'Feature: codium-ai-enhancement, Property 2.1: Manual Text Selection Flow - '
      'For any text input and page number, the system should create explanation '
      'with correct page reference',
      () async {
        final testCases = _generatePropertyTestCases(100);

        for (final testCase in testCases) {
          when(
            mockAiRepository.explainText(
              text: testCase.selectedText,
              context: testCase.context,
            ),
          ).thenAnswer((_) async => testCase.expectedExplanation);

          when(
            mockAiRepository.searchWeb(testCase.selectedText),
          ).thenAnswer((_) async => testCase.sources);

          when(
            mockStorageRepository.saveExplanation(any),
          ).thenAnswer((_) async => {});

          final result = await useCase.execute(
            selectedText: testCase.selectedText,
            context: testCase.context,
            pdfBookId: testCase.pdfBookId,
            pageNumber: testCase.pageNumber,
          );

          expect(
            result.pageNumber,
            equals(testCase.pageNumber),
            reason:
                'Page number should match input for text: "${testCase.selectedText}" '
                'on page ${testCase.pageNumber}',
          );

          expect(
            result.pdfBookId,
            equals(testCase.pdfBookId),
            reason: 'PDF book ID should match input',
          );

          expect(
            result.selectedText,
            equals(testCase.selectedText),
            reason: 'Selected text should be preserved',
          );

          expect(
            result.explanation,
            equals(testCase.expectedExplanation),
            reason: 'Explanation should match AI response',
          );

          expect(
            result.sources,
            equals(testCase.sources),
            reason: 'Sources should be included in explanation',
          );

          expect(
            result.id,
            isNotEmpty,
            reason: 'Explanation should have a unique ID',
          );

          expect(
            result.createdAt,
            isNotNull,
            reason: 'Explanation should have a creation timestamp',
          );

          final captured =
              verify(
                    mockStorageRepository.saveExplanation(captureAny),
                  ).captured.single
                  as Explanation;

          expect(
            captured.pageNumber,
            equals(testCase.pageNumber),
            reason: 'Saved explanation should preserve page number',
          );

          expect(
            captured.pdfBookId,
            equals(testCase.pdfBookId),
            reason: 'Saved explanation should preserve PDF book ID',
          );

          reset(mockAiRepository);
          reset(mockStorageRepository);
        }
      },
    );

    test(
      'Property 2.1 - Edge Cases: Empty sources list should not affect page reference',
      () async {
        final testCases = _generateEdgeCaseTestCases();

        for (final testCase in testCases) {
          when(
            mockAiRepository.explainText(
              text: testCase.selectedText,
              context: testCase.context,
            ),
          ).thenAnswer((_) async => testCase.expectedExplanation);

          when(
            mockAiRepository.searchWeb(testCase.selectedText),
          ).thenAnswer((_) async => <SearchSource>[]);

          when(
            mockStorageRepository.saveExplanation(any),
          ).thenAnswer((_) async => {});

          final result = await useCase.execute(
            selectedText: testCase.selectedText,
            context: testCase.context,
            pdfBookId: testCase.pdfBookId,
            pageNumber: testCase.pageNumber,
          );

          expect(
            result.pageNumber,
            equals(testCase.pageNumber),
            reason:
                'Page number should be preserved even with empty sources for page ${testCase.pageNumber}',
          );

          expect(
            result.sources,
            isEmpty,
            reason:
                'Sources should be empty when web search returns no results',
          );

          reset(mockAiRepository);
          reset(mockStorageRepository);
        }
      },
    );

    test('Property 2.1 - Boundary Cases: Page numbers at boundaries', () async {
      final boundaryPages = [0, 1, 100, 999, 9999];

      for (final pageNumber in boundaryPages) {
        when(
          mockAiRepository.explainText(
            text: anyNamed('text'),
            context: anyNamed('context'),
          ),
        ).thenAnswer((_) async => 'Explanation for page $pageNumber');

        when(
          mockAiRepository.searchWeb(any),
        ).thenAnswer((_) async => <SearchSource>[]);

        when(
          mockStorageRepository.saveExplanation(any),
        ).thenAnswer((_) async => {});

        final result = await useCase.execute(
          selectedText: 'test text',
          context: 'test context',
          pdfBookId: 'book-boundary-test',
          pageNumber: pageNumber,
        );

        expect(
          result.pageNumber,
          equals(pageNumber),
          reason: 'Boundary page number $pageNumber should be preserved',
        );

        reset(mockAiRepository);
        reset(mockStorageRepository);
      }
    });

    test(
      'Property 2.1 - Consistency: Multiple calls with same input produce consistent page references',
      () async {
        const selectedText = 'consistency test';
        const context = 'test context';
        const pdfBookId = 'book-consistency';
        const pageNumber = 42;

        when(
          mockAiRepository.explainText(text: selectedText, context: context),
        ).thenAnswer((_) async => 'Consistent explanation');

        when(
          mockAiRepository.searchWeb(selectedText),
        ).thenAnswer((_) async => <SearchSource>[]);

        when(
          mockStorageRepository.saveExplanation(any),
        ).thenAnswer((_) async => {});

        final results = <Explanation>[];
        for (var i = 0; i < 10; i++) {
          final result = await useCase.execute(
            selectedText: selectedText,
            context: context,
            pdfBookId: pdfBookId,
            pageNumber: pageNumber,
          );
          results.add(result);
        }

        for (final result in results) {
          expect(
            result.pageNumber,
            equals(pageNumber),
            reason: 'All explanations should have the same page number',
          );
          expect(
            result.pdfBookId,
            equals(pdfBookId),
            reason: 'All explanations should have the same PDF book ID',
          );
        }
      },
    );
  });
}

class _PropertyTestCase {
  _PropertyTestCase({
    required this.selectedText,
    required this.context,
    required this.pdfBookId,
    required this.pageNumber,
    required this.expectedExplanation,
    required this.sources,
  });

  final String selectedText;
  final String context;
  final String pdfBookId;
  final int pageNumber;
  final String expectedExplanation;
  final List<SearchSource> sources;
}

List<_PropertyTestCase> _generatePropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <_PropertyTestCase>[];

  final sampleTexts = [
    'polymorphism',
    'inheritance',
    'encapsulation',
    'abstraction',
    'interface',
    'class',
    'object',
    'method',
    'function',
    'variable',
    'closure',
    'callback',
    'promise',
    'async/await',
    'recursion',
    'algorithm',
    'data structure',
    'linked list',
    'binary tree',
    'hash table',
    'stack',
    'queue',
    'graph',
    'sorting',
    'searching',
    'dynamic programming',
    'greedy algorithm',
    'divide and conquer',
    'backtracking',
    'memoization',
  ];

  final sampleContexts = [
    'Object-oriented programming concepts',
    'Functional programming paradigms',
    'Data structures and algorithms',
    'Software design patterns',
    'Computer science fundamentals',
  ];

  final sampleSources = [
    [
      const SearchSource(
        title: 'Programming Concepts',
        snippet: 'Detailed explanation of programming concepts...',
        url: 'https://example.com/concepts',
      ),
    ],
    [
      const SearchSource(
        title: 'Tutorial',
        snippet: 'Step-by-step tutorial...',
        url: 'https://example.com/tutorial',
      ),
      const SearchSource(
        title: 'Documentation',
        snippet: 'Official documentation...',
        url: 'https://example.com/docs',
      ),
    ],
    <SearchSource>[],
  ];

  for (var i = 0; i < count; i++) {
    final textIndex = (random + i * 7) % sampleTexts.length;
    final contextIndex = (random + i * 11) % sampleContexts.length;
    final sourcesIndex = (random + i * 13) % sampleSources.length;
    final pageNumber = (random + i * 17) % 500;

    cases.add(
      _PropertyTestCase(
        selectedText: sampleTexts[textIndex],
        context: sampleContexts[contextIndex],
        pdfBookId: 'book-${i % 10}',
        pageNumber: pageNumber,
        expectedExplanation:
            'Explanation for ${sampleTexts[textIndex]} on page $pageNumber',
        sources: sampleSources[sourcesIndex],
      ),
    );
  }

  return cases;
}

List<_PropertyTestCase> _generateEdgeCaseTestCases() {
  return [
    _PropertyTestCase(
      selectedText: 'a',
      context: 'Single character',
      pdfBookId: 'book-edge-1',
      pageNumber: 0,
      expectedExplanation: 'Explanation for single character',
      sources: [],
    ),
    _PropertyTestCase(
      selectedText: 'Very long text ' * 50,
      context: 'Long text context',
      pdfBookId: 'book-edge-2',
      pageNumber: 999,
      expectedExplanation: 'Explanation for very long text',
      sources: [],
    ),
    _PropertyTestCase(
      selectedText: 'Special chars: @#\$%^&*()',
      context: 'Special characters',
      pdfBookId: 'book-edge-3',
      pageNumber: 50,
      expectedExplanation: 'Explanation for special characters',
      sources: [],
    ),
    _PropertyTestCase(
      selectedText: 'Unicode: 你好世界 🌍',
      context: 'Unicode text',
      pdfBookId: 'book-edge-4',
      pageNumber: 25,
      expectedExplanation: 'Explanation for unicode text',
      sources: [],
    ),
  ];
}
