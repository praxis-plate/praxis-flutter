part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingInitialState extends OnboardingState {}

final class OnboardingPage1State extends OnboardingState {}

final class OnboardingPage2State extends OnboardingState {}

final class OnboardingPage3State extends OnboardingState {}

final class OnboardingLanguageSelectionState extends OnboardingState {}

final class OnboardingCompleteState extends OnboardingState {
  final String? selectedLanguage;

  const OnboardingCompleteState({this.selectedLanguage});

  @override
  List<Object?> get props => [selectedLanguage];
}
