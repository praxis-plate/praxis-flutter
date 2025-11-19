import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/models/ai_explanation/search_source.dart';
import 'package:codium/features/ai_explanation/bloc/ai_explanation_bloc.dart';
import 'package:codium/features/ai_explanation/widgets/explanation_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'explanation_bottom_sheet_test.mocks.dart';

@GenerateMocks([AiExplanationBloc])
void main() {
  late MockAiExplanationBloc mockBloc;

  setUp(() {
    mockBloc = MockAiExplanationBloc();
    provideDummy<AiExplanationState>(AiExplanationInitialState());
  });

  Widget createTestWidget(AiExplanationState state) {
    when(mockBloc.state).thenReturn(state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AiExplanationBloc>.value(
          value: mockBloc,
          child: const ExplanationBottomSheet(),
        ),
      ),
    );
  }

  group('ExplanationBottomSheet - Property Tests', () {
    testWidgets(
      'Feature: codium-ai-enhancement, Property 4: AI Response Display Format - '
      'For any AI-generated explanation, the system should display it '
      'in a bottom sheet with markdown formatting',
      (tester) async {
        final testCases = _generatePropertyTestCases(10);

        for (final testCase in testCases) {
          final testBloc = MockAiExplanationBloc();
          provideDummy<AiExplanationState>(AiExplanationInitialState());

          final state = AiExplanationLoadedState(explanation: testCase);
          when(testBloc.state).thenReturn(state);
          when(testBloc.stream).thenAnswer((_) => Stream.value(state));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BlocProvider<AiExplanationBloc>.value(
                  value: testBloc,
                  child: const ExplanationBottomSheet(),
                ),
              ),
            ),
          );
          await tester.pump();

          expect(find.byType(MarkdownBody), findsOneWidget);

          final markdownWidget = tester.widget<MarkdownBody>(
            find.byType(MarkdownBody),
          );
          expect(markdownWidget.data, testCase.explanation);

          expect(find.text('"${testCase.selectedText}"'), findsOneWidget);

          expect(find.text('Explanation'), findsOneWidget);
        }
      },
    );

    testWidgets('Feature: codium-ai-enhancement, Property 6: Sources Display - '
        'For any explanation with search results, the system should display '
        'clickable source links at the bottom', (tester) async {
      final testCases = _generateSourcesPropertyTestCases(10);

      for (final testCase in testCases) {
        final testBloc = MockAiExplanationBloc();
        provideDummy<AiExplanationState>(AiExplanationInitialState());

        final state = AiExplanationLoadedState(explanation: testCase);
        when(testBloc.state).thenReturn(state);
        when(testBloc.stream).thenAnswer((_) => Stream.value(state));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider<AiExplanationBloc>.value(
                value: testBloc,
                child: const ExplanationBottomSheet(),
              ),
            ),
          ),
        );
        await tester.pump();

        if (testCase.sources.isNotEmpty) {
          expect(find.text('Sources'), findsOneWidget);

          for (final source in testCase.sources) {
            expect(find.text(source.title), findsOneWidget);
            expect(find.text(source.snippet), findsOneWidget);
            expect(find.text(source.url), findsOneWidget);

            expect(find.byType(InkWell), findsWidgets);
          }
        } else {
          expect(find.text('Sources'), findsNothing);
        }
      }
    });
  });

  group('ExplanationBottomSheet - Unit Tests', () {
    testWidgets('should show loading state with selected text', (tester) async {
      const state = AiExplanationLoadingState(selectedText: 'test variable');

      await tester.pumpWidget(createTestWidget(state));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Generating explanation...'), findsOneWidget);
      expect(find.textContaining('test variable'), findsOneWidget);
    });

    testWidgets('should show explanation with markdown formatting', (
      tester,
    ) async {
      final explanation = Explanation(
        id: '1',
        pdfBookId: 'book1',
        pageNumber: 5,
        selectedText: 'variable',
        explanation: '# Variable\n\nA **variable** is a storage location.',
        sources: const [],
        createdAt: DateTime.now(),
      );

      final state = AiExplanationLoadedState(explanation: explanation);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.byType(MarkdownBody), findsOneWidget);
      expect(find.text('Explanation'), findsOneWidget);
      expect(find.text('"variable"'), findsOneWidget);
    });

    testWidgets('should show sources when available', (tester) async {
      final explanation = Explanation(
        id: '1',
        pdfBookId: 'book1',
        pageNumber: 5,
        selectedText: 'variable',
        explanation: 'A variable is a storage location.',
        sources: const [
          SearchSource(
            title: 'Dart Variables',
            snippet: 'Variables in Dart...',
            url: 'https://dart.dev/variables',
          ),
        ],
        createdAt: DateTime.now(),
      );

      final state = AiExplanationLoadedState(explanation: explanation);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('Sources'), findsOneWidget);
      expect(find.text('Dart Variables'), findsOneWidget);
      expect(find.text('Variables in Dart...'), findsOneWidget);
    });

    testWidgets('should show error state with retry button', (tester) async {
      const state = AiExplanationErrorState(
        message: 'Failed to generate explanation',
        canRetry: true,
      );

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Failed to generate explanation'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should show offline indicator when offline', (tester) async {
      const state = AiExplanationErrorState(
        message: 'No internet connection',
        canRetry: true,
        isOffline: true,
      );

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('should not show retry button when canRetry is false', (
      tester,
    ) async {
      const state = AiExplanationErrorState(
        message: 'Rate limit exceeded',
        canRetry: false,
      );

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsNothing);
    });
  });
}

List<Explanation> _generatePropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <Explanation>[];

  final sampleTexts = [
    'variable',
    'function',
    'class',
    'async/await',
    'closure',
    'recursion',
    'polymorphism',
    'inheritance',
  ];

  final sampleExplanations = [
    '# Definition\n\nThis is a **fundamental** concept.',
    'A simple explanation with *emphasis*.',
    '## Overview\n\n- Point 1\n- Point 2\n- Point 3',
    'Code example:\n```dart\nvoid main() {}\n```',
    'This concept is used in programming.',
  ];

  for (var i = 0; i < count; i++) {
    final textIndex = (random + i * 7) % sampleTexts.length;
    final explanationIndex = (random + i * 13) % sampleExplanations.length;

    cases.add(
      Explanation(
        id: 'id_$i',
        pdfBookId: 'book_${i % 5}',
        pageNumber: i % 100,
        selectedText: sampleTexts[textIndex],
        explanation: sampleExplanations[explanationIndex],
        sources: const [],
        createdAt: DateTime.now(),
      ),
    );
  }

  return cases;
}

List<Explanation> _generateSourcesPropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <Explanation>[];

  final sampleTexts = ['variable', 'function', 'class', 'async/await'];

  final sampleTitles = [
    'Dart Documentation',
    'Flutter Guide',
    'Stack Overflow',
    'Medium Article',
  ];

  final sampleSnippets = [
    'This is a comprehensive guide...',
    'Learn how to implement...',
    'Best practices for...',
    'Understanding the basics...',
  ];

  for (var i = 0; i < count; i++) {
    final textIndex = (random + i * 7) % sampleTexts.length;
    final sourceCount = (i % 3);

    final sources = <SearchSource>[];
    for (var j = 0; j < sourceCount; j++) {
      final titleIndex = (random + i * 11 + j * 13) % sampleTitles.length;
      final snippetIndex = (random + i * 17 + j * 19) % sampleSnippets.length;

      sources.add(
        SearchSource(
          title: sampleTitles[titleIndex],
          snippet: sampleSnippets[snippetIndex],
          url: 'https://example.com/source-$i-$j',
        ),
      );
    }

    cases.add(
      Explanation(
        id: 'id_$i',
        pdfBookId: 'book_${i % 5}',
        pageNumber: i % 100,
        selectedText: sampleTexts[textIndex],
        explanation: 'Explanation for ${sampleTexts[textIndex]}',
        sources: sources,
        createdAt: DateTime.now(),
      ),
    );
  }

  return cases;
}
