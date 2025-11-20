part of 'explanation_history_bloc.dart';

sealed class ExplanationHistoryState extends Equatable {
  const ExplanationHistoryState();

  @override
  List<Object?> get props => [];
}

final class ExplanationHistoryInitialState extends ExplanationHistoryState {}

final class ExplanationHistoryLoadingState extends ExplanationHistoryState {}

final class ExplanationHistoryLoadedState extends ExplanationHistoryState {
  final Map<String, List<Explanation>> groupedExplanations;
  final List<Explanation> allExplanations;
  final String searchQuery;

  const ExplanationHistoryLoadedState({
    required this.groupedExplanations,
    required this.allExplanations,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [groupedExplanations, allExplanations, searchQuery];
}

final class ExplanationHistoryErrorState extends ExplanationHistoryState {
  final AppErrorCode errorCode;
  final String? message;
  final bool canRetry;

  const ExplanationHistoryErrorState({
    required this.errorCode,
    this.message,
    this.canRetry = false,
  });

  @override
  List<Object?> get props => [errorCode, message, canRetry];
}
