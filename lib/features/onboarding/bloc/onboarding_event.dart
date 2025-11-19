part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class NextPageEvent extends OnboardingEvent {}

class CompleteOnboardingEvent extends OnboardingEvent {}

class SelectLanguageEvent extends OnboardingEvent {
  final String language;

  const SelectLanguageEvent(this.language);

  @override
  List<Object> get props => [language];
}

class CheckOnboardingStatusEvent extends OnboardingEvent {}
