import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _selectedLanguageKey = 'selected_language';

  OnboardingBloc() : super(OnboardingInitialState()) {
    on<CheckOnboardingStatusEvent>(_onCheckOnboardingStatus);
    on<NextPageEvent>(_onNextPage);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
    on<SelectLanguageEvent>(_onSelectLanguage);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatusEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isComplete = prefs.getBool(_onboardingCompleteKey) ?? false;
    final selectedLanguage = prefs.getString(_selectedLanguageKey);

    if (isComplete) {
      emit(OnboardingCompleteState(selectedLanguage: selectedLanguage));
    } else {
      emit(OnboardingPage1State());
    }
  }

  Future<void> _onNextPage(
    NextPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingPage1State) {
      emit(OnboardingPage2State());
    } else if (state is OnboardingPage2State) {
      emit(OnboardingPage3State());
    } else if (state is OnboardingPage3State) {
      emit(OnboardingLanguageSelectionState());
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);

    final selectedLanguage = prefs.getString(_selectedLanguageKey);
    emit(OnboardingCompleteState(selectedLanguage: selectedLanguage));
  }

  Future<void> _onSelectLanguage(
    SelectLanguageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageKey, event.language);
    await prefs.setBool(_onboardingCompleteKey, true);

    emit(OnboardingCompleteState(selectedLanguage: event.language));
  }
}
