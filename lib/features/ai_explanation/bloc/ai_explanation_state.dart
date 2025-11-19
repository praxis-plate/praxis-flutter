part of 'ai_explanation_bloc.dart';

sealed class AiExplanationState extends Equatable {
  const AiExplanationState();

  @override
  List<Object?> get props => [];
}

final class AiExplanationInitialState extends AiExplanationState {}

final class AiExplanationLoadingState extends AiExplanationState {
  final String selectedText;

  const AiExplanationLoadingState({required this.selectedText});

  @override
  List<Object?> get props => [selectedText];
}

final class AiExplanationLoadedState extends AiExplanationState {
  final Explanation explanation;

  const AiExplanationLoadedState({required this.explanation});

  @override
  List<Object?> get props => [explanation];
}

final class AiExplanationErrorState extends AiExplanationState {
  final String message;
  final bool canRetry;
  final bool isOffline;

  const AiExplanationErrorState({
    required this.message,
    this.canRetry = true,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [message, canRetry, isOffline];
}
