import 'package:codium/data/datasources/remote/gemini_datasource.dart';
import 'package:codium/data/datasources/remote/search_datasource.dart';
import 'package:codium/data/repositories/ai_repository_impl.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ai_repository_impl_test.mocks.dart';

@GenerateMocks([GeminiDataSource, SearchDataSource])
void main() {
  late AiRepositoryImpl repository;
  late MockGeminiDataSource mockGeminiDataSource;
  late MockSearchDataSource mockSearchDataSource;

  setUp(() {
    mockGeminiDataSource = MockGeminiDataSource();
    mockSearchDataSource = MockSearchDataSource();
    repository = AiRepositoryImpl(
      geminiDataSource: mockGeminiDataSource,
      searchDataSource: mockSearchDataSource,
    );
  });

  group('AiRepositoryImpl - Property Tests', () {
    test(
      'Feature: codium-ai-enhancement, Property 3: Explain Triggers API Call - '
      'For any selected text, when explainText is called, '
      'the system should send the text with context to Gemini API',
      () async {
        final testCases = _generatePropertyTestCases(100);

        for (final testCase in testCases) {
          when(
            mockGeminiDataSource.explainText(
              text: testCase.text,
              context: testCase.context,
            ),
          ).thenAnswer((_) async => 'Mock explanation for ${testCase.text}');

          await repository.explainText(
            text: testCase.text,
            context: testCase.context,
          );

          verify(
            mockGeminiDataSource.explainText(
              text: testCase.text,
              context: testCase.context,
            ),
          ).called(1);

          reset(mockGeminiDataSource);
        }
      },
    );
  });

  group('AiRepositoryImpl - Unit Tests', () {
    test('should return explanation when API call succeeds', () async {
      const text = 'variable';
      const context = 'In programming, a variable is...';
      const expectedExplanation = 'A variable is a storage location...';

      when(
        mockGeminiDataSource.explainText(text: text, context: context),
      ).thenAnswer((_) async => expectedExplanation);

      final result = await repository.explainText(text: text, context: context);

      expect(result, expectedExplanation);
      verify(
        mockGeminiDataSource.explainText(text: text, context: context),
      ).called(1);
    });

    test(
      'should throw exception with rate limit message when rate limited',
      () async {
        const text = 'variable';
        const context = 'In programming...';

        when(
          mockGeminiDataSource.explainText(text: text, context: context),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Rate limit exceeded',
          ),
        );

        expect(
          () => repository.explainText(text: text, context: context),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('rate limits'),
            ),
          ),
        );
      },
    );

    test('should throw exception when API call fails', () async {
      const text = 'variable';
      const context = 'In programming...';

      when(
        mockGeminiDataSource.explainText(text: text, context: context),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network error',
        ),
      );

      expect(
        () => repository.explainText(text: text, context: context),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to generate explanation'),
          ),
        ),
      );
    });

    test('should return search results when web search succeeds', () async {
      const query = 'Dart programming';
      final expectedResults = [
        SearchSource(
          title: 'Dart Language',
          snippet: 'Dart is a programming language...',
          url: 'https://dart.dev',
        ),
      ];

      when(
        mockSearchDataSource.searchWeb(query),
      ).thenAnswer((_) async => expectedResults);

      final result = await repository.searchWeb(query);

      expect(result, expectedResults);
      verify(mockSearchDataSource.searchWeb(query)).called(1);
    });

    test('should return empty list when web search times out', () async {
      const query = 'Dart programming';

      when(mockSearchDataSource.searchWeb(query)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.searchWeb(query);

      expect(result, isEmpty);
    });

    test('should return empty list when web search fails', () async {
      const query = 'Dart programming';

      when(mockSearchDataSource.searchWeb(query)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network error',
        ),
      );

      final result = await repository.searchWeb(query);

      expect(result, isEmpty);
    });
  });
}

class _PropertyTestCase {
  _PropertyTestCase({required this.text, required this.context});

  final String text;
  final String context;
}

List<_PropertyTestCase> _generatePropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <_PropertyTestCase>[];

  final sampleTexts = [
    'variable',
    'function',
    'class',
    'interface',
    'async',
    'await',
    'promise',
    'callback',
    'closure',
    'recursion',
    'algorithm',
    'data structure',
    'polymorphism',
    'inheritance',
    'encapsulation',
    'abstraction',
    'dependency injection',
    'design pattern',
    'singleton',
    'factory',
    'observer',
    'strategy',
    'decorator',
    'adapter',
    'facade',
    'proxy',
    'iterator',
    'composite',
    'command',
    'state',
    'template method',
    'visitor',
    'chain of responsibility',
    'mediator',
    'memento',
    'prototype',
    'builder',
    'bridge',
    'flyweight',
  ];

  final sampleContexts = [
    'In programming, this concept is fundamental.',
    'This is commonly used in object-oriented programming.',
    'Developers use this pattern to solve common problems.',
    'This technique helps manage complexity in large codebases.',
    'Understanding this is crucial for writing efficient code.',
    'This approach improves code maintainability and readability.',
    'Modern frameworks heavily rely on this concept.',
    'This pattern promotes loose coupling between components.',
    'Functional programming emphasizes this principle.',
    'This is a key concept in software architecture.',
  ];

  for (var i = 0; i < count; i++) {
    final textIndex = (random + i * 7) % sampleTexts.length;
    final contextIndex = (random + i * 13) % sampleContexts.length;

    cases.add(
      _PropertyTestCase(
        text: sampleTexts[textIndex],
        context: sampleContexts[contextIndex],
      ),
    );
  }

  return cases;
}
