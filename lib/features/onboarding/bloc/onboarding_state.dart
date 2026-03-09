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

final class OnboardingCompleteState extends OnboardingState {}

final class OnboardingErrorState extends OnboardingState {
  final AppErrorCode errorCode;
  final String? message;

  const OnboardingErrorState({required this.errorCode, this.message});

  @override
  List<Object?> get props => [errorCode, message];
}
