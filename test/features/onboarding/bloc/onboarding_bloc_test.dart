import 'package:codium/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OnboardingBloc bloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    bloc = OnboardingBloc();
  });

  tearDown(() {
    bloc.close();
  });

  group('OnboardingBloc - Property Tests', () {
    test(
      'Feature: codium-ai-enhancement, Property 21: Onboarding State Persistence - '
      'For any user who completes onboarding, the system should not show '
      'onboarding again on subsequent app launches',
      () async {
        final testCases = _generatePropertyTestCases(100);

        for (final testCase in testCases) {
          SharedPreferences.setMockInitialValues({});
          final testBloc = OnboardingBloc();

          final language = testCase['language'] as String?;
          final shouldCompleteWithLanguage =
              testCase['completeWithLanguage'] as bool;

          if (shouldCompleteWithLanguage && language != null) {
            testBloc.add(SelectLanguageEvent(language));
            await testBloc.stream.first;

            final state = testBloc.state;
            expect(state, isA<OnboardingCompleteState>());
            expect(
              (state as OnboardingCompleteState).selectedLanguage,
              equals(language),
            );

            final prefs = await SharedPreferences.getInstance();
            final isComplete = prefs.getBool('onboarding_complete') ?? false;
            final savedLanguage = prefs.getString('selected_language');

            expect(isComplete, isTrue);
            expect(savedLanguage, equals(language));
          } else {
            testBloc.add(CompleteOnboardingEvent());
            await testBloc.stream.first;

            final state = testBloc.state;
            expect(state, isA<OnboardingCompleteState>());

            final prefs = await SharedPreferences.getInstance();
            final isComplete = prefs.getBool('onboarding_complete') ?? false;

            expect(isComplete, isTrue);
          }

          final newBloc = OnboardingBloc();
          newBloc.add(CheckOnboardingStatusEvent());
          await newBloc.stream.first;

          final newState = newBloc.state;
          expect(
            newState,
            isA<OnboardingCompleteState>(),
            reason:
                'After completing onboarding, checking status should return OnboardingCompleteState',
          );

          if (shouldCompleteWithLanguage && language != null) {
            expect(
              (newState as OnboardingCompleteState).selectedLanguage,
              equals(language),
              reason: 'Selected language should persist across app launches',
            );
          }

          await testBloc.close();
          await newBloc.close();
        }
      },
    );
  });

  group('OnboardingBloc - Unit Tests', () {
    test('should start with OnboardingInitialState', () {
      expect(bloc.state, isA<OnboardingInitialState>());
    });

    test(
      'should emit OnboardingPage1State when onboarding is not complete',
      () async {
        bloc.add(CheckOnboardingStatusEvent());

        await expectLater(bloc.stream, emits(isA<OnboardingPage1State>()));
      },
    );

    test(
      'should emit OnboardingCompleteState when onboarding is already complete',
      () async {
        SharedPreferences.setMockInitialValues({
          'onboarding_complete': true,
          'selected_language': 'Dart',
        });

        final testBloc = OnboardingBloc();
        testBloc.add(CheckOnboardingStatusEvent());

        await expectLater(
          testBloc.stream,
          emits(
            isA<OnboardingCompleteState>().having(
              (state) => state.selectedLanguage,
              'selectedLanguage',
              'Dart',
            ),
          ),
        );

        await testBloc.close();
      },
    );

    test('should navigate through onboarding pages', () async {
      bloc.add(CheckOnboardingStatusEvent());
      await bloc.stream.first;

      bloc.add(NextPageEvent());
      await expectLater(bloc.stream, emits(isA<OnboardingPage2State>()));

      bloc.add(NextPageEvent());
      await expectLater(bloc.stream, emits(isA<OnboardingPage3State>()));

      bloc.add(NextPageEvent());
      await expectLater(
        bloc.stream,
        emits(isA<OnboardingLanguageSelectionState>()),
      );
    });

    test('should complete onboarding and persist state', () async {
      bloc.add(CompleteOnboardingEvent());

      await expectLater(bloc.stream, emits(isA<OnboardingCompleteState>()));

      final prefs = await SharedPreferences.getInstance();
      final isComplete = prefs.getBool('onboarding_complete');

      expect(isComplete, isTrue);
    });

    test('should save language selection and complete onboarding', () async {
      bloc.add(const SelectLanguageEvent('Python'));

      await expectLater(
        bloc.stream,
        emits(
          isA<OnboardingCompleteState>().having(
            (state) => state.selectedLanguage,
            'selectedLanguage',
            'Python',
          ),
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      final isComplete = prefs.getBool('onboarding_complete');
      final savedLanguage = prefs.getString('selected_language');

      expect(isComplete, isTrue);
      expect(savedLanguage, equals('Python'));
    });

    test(
      'should persist onboarding completion across bloc instances',
      () async {
        bloc.add(const SelectLanguageEvent('JavaScript'));
        await bloc.stream.first;

        final newBloc = OnboardingBloc();
        newBloc.add(CheckOnboardingStatusEvent());

        await expectLater(
          newBloc.stream,
          emits(
            isA<OnboardingCompleteState>().having(
              (state) => state.selectedLanguage,
              'selectedLanguage',
              'JavaScript',
            ),
          ),
        );

        await newBloc.close();
      },
    );
  });
}

List<Map<String, dynamic>> _generatePropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <Map<String, dynamic>>[];

  final sampleLanguages = [
    'Dart',
    'Python',
    'JavaScript',
    'Java',
    'C++',
    'Go',
    'Rust',
    'TypeScript',
    'Kotlin',
    'Swift',
    'Ruby',
    'PHP',
    'C#',
    'Scala',
    'Haskell',
    'Elixir',
    'Clojure',
    'F#',
    'OCaml',
    'Erlang',
  ];

  for (var i = 0; i < count; i++) {
    final completeWithLanguage = ((random + i * 7) % 2) == 0;
    final languageIndex = (random + i * 11) % sampleLanguages.length;
    final language = sampleLanguages[languageIndex];

    cases.add({
      'completeWithLanguage': completeWithLanguage,
      'language': completeWithLanguage ? language : null,
    });
  }

  return cases;
}
