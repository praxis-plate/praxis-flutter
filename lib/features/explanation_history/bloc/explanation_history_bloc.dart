import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/usecases/delete_explanation_usecase.dart';
import 'package:codium/domain/usecases/get_explanation_history_usecase.dart';
import 'package:codium/domain/usecases/search_explanation_history_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'explanation_history_event.dart';
part 'explanation_history_state.dart';

class ExplanationHistoryBloc
    extends Bloc<ExplanationHistoryEvent, ExplanationHistoryState> {
  final GetExplanationHistoryUseCase _getExplanationHistoryUseCase;
  final SearchExplanationHistoryUseCase _searchExplanationHistoryUseCase;
  final DeleteExplanationUseCase _deleteExplanationUseCase;

  ExplanationHistoryBloc({
    required GetExplanationHistoryUseCase getExplanationHistoryUseCase,
    required SearchExplanationHistoryUseCase searchExplanationHistoryUseCase,
    required DeleteExplanationUseCase deleteExplanationUseCase,
  }) : _getExplanationHistoryUseCase = getExplanationHistoryUseCase,
       _searchExplanationHistoryUseCase = searchExplanationHistoryUseCase,
       _deleteExplanationUseCase = deleteExplanationUseCase,
       super(ExplanationHistoryInitialState()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<SearchHistoryEvent>(_onSearchHistory);
    on<DeleteHistoryEvent>(_onDeleteHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<ExplanationHistoryState> emit,
  ) async {
    emit(ExplanationHistoryLoadingState());
    try {
      final explanations = await _getExplanationHistoryUseCase.execute();
      final grouped = _groupExplanationsByPdf(explanations);
      emit(
        ExplanationHistoryLoadedState(
          groupedExplanations: grouped,
          allExplanations: explanations,
        ),
      );
    } catch (e) {
      emit(ExplanationHistoryErrorState(e.toString()));
    }
  }

  Future<void> _onSearchHistory(
    SearchHistoryEvent event,
    Emitter<ExplanationHistoryState> emit,
  ) async {
    if (state is ExplanationHistoryLoadedState) {
      final currentState = state as ExplanationHistoryLoadedState;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        final grouped = _groupExplanationsByPdf(currentState.allExplanations);
        emit(
          ExplanationHistoryLoadedState(
            groupedExplanations: grouped,
            allExplanations: currentState.allExplanations,
            searchQuery: query,
          ),
        );
      } else {
        try {
          final filtered = await _searchExplanationHistoryUseCase.execute(
            query,
          );
          final grouped = _groupExplanationsByPdf(filtered);
          emit(
            ExplanationHistoryLoadedState(
              groupedExplanations: grouped,
              allExplanations: currentState.allExplanations,
              searchQuery: query,
            ),
          );
        } catch (e) {
          emit(ExplanationHistoryErrorState(e.toString()));
        }
      }
    }
  }

  Future<void> _onDeleteHistory(
    DeleteHistoryEvent event,
    Emitter<ExplanationHistoryState> emit,
  ) async {
    try {
      await _deleteExplanationUseCase.execute(event.explanationId);
      add(LoadHistoryEvent());
    } catch (e) {
      emit(ExplanationHistoryErrorState(e.toString()));
    }
  }

  Map<String, List<Explanation>> _groupExplanationsByPdf(
    List<Explanation> explanations,
  ) {
    final Map<String, List<Explanation>> grouped = {};

    for (final explanation in explanations) {
      if (!grouped.containsKey(explanation.pdfBookId)) {
        grouped[explanation.pdfBookId] = [];
      }
      grouped[explanation.pdfBookId]!.add(explanation);
    }

    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return grouped;
  }
}
