import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/exceptions/app_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const String _onboardingCompleteKey = 'onboarding_complete';

  OnboardingBloc() : super(OnboardingInitialState()) {
    on<CheckOnboardingStatusEvent>(_onCheckOnboardingStatus);
    on<NextPageEvent>(_onNextPage);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatusEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isComplete = prefs.getBool(_onboardingCompleteKey) ?? false;

      if (isComplete) {
        emit(OnboardingCompleteState());
      } else {
        emit(OnboardingPage1State());
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
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
      add(CompleteOnboardingEvent());
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompleteKey, true);

      emit(OnboardingCompleteState());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError
          ? e
          : const UnknownError(message: 'Failed to save onboarding status');
      emit(OnboardingErrorState(errorCode: error.code, message: error.message));
    }
  }
}
