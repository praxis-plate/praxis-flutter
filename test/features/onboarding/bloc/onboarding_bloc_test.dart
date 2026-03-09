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
        for (var i = 0; i < 100; i++) {
          SharedPreferences.setMockInitialValues({});
          final testBloc = OnboardingBloc();
          testBloc.add(CompleteOnboardingEvent());
          await testBloc.stream.first;

          final state = testBloc.state;
          expect(state, isA<OnboardingCompleteState>());

          final prefs = await SharedPreferences.getInstance();
          final isComplete = prefs.getBool('onboarding_complete') ?? false;

          expect(isComplete, isTrue);

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
        SharedPreferences.setMockInitialValues({'onboarding_complete': true});

        final testBloc = OnboardingBloc();
        testBloc.add(CheckOnboardingStatusEvent());

        await expectLater(
          testBloc.stream,
          emits(isA<OnboardingCompleteState>()),
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
      await expectLater(bloc.stream, emits(isA<OnboardingCompleteState>()));
    });

    test('should complete onboarding and persist state', () async {
      bloc.add(CompleteOnboardingEvent());

      await expectLater(bloc.stream, emits(isA<OnboardingCompleteState>()));

      final prefs = await SharedPreferences.getInstance();
      final isComplete = prefs.getBool('onboarding_complete');

      expect(isComplete, isTrue);
    });

    test(
      'should persist onboarding completion across bloc instances',
      () async {
        bloc.add(CompleteOnboardingEvent());
        await bloc.stream.first;

        final newBloc = OnboardingBloc();
        newBloc.add(CheckOnboardingStatusEvent());

        await expectLater(
          newBloc.stream,
          emits(isA<OnboardingCompleteState>()),
        );

        await newBloc.close();
      },
    );
  });
}
