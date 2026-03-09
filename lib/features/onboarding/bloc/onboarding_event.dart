part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class NextPageEvent extends OnboardingEvent {}

class CompleteOnboardingEvent extends OnboardingEvent {}

class CheckOnboardingStatusEvent extends OnboardingEvent {}
