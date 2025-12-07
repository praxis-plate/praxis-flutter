part of 'explanation_history_bloc.dart';

sealed class ExplanationHistoryEvent extends Equatable {
  const ExplanationHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistoryEvent extends ExplanationHistoryEvent {}

class SearchHistoryEvent extends ExplanationHistoryEvent {
  final String query;

  const SearchHistoryEvent(this.query);

  @override
  List<Object> get props => [query];
}

class DeleteHistoryEvent extends ExplanationHistoryEvent {
  final int explanationId;

  const DeleteHistoryEvent(this.explanationId);

  @override
  List<Object> get props => [explanationId];
}
