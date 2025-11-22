import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/exceptions/app_exception.dart';
import 'package:codium/core/utils/retry_logic.dart';
import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
      final explanations = await RetryLogic.retry(
        operation: () => _getExplanationHistoryUseCase(),
        maxAttempts: 2,
        shouldRetry: (e) => e is DatabaseError,
      );
      final grouped = _groupExplanationsByPdf(explanations);
      emit(
        ExplanationHistoryLoadedState(
          groupedExplanations: grouped,
          allExplanations: explanations,
        ),
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError ? e : const UnknownError();
      emit(
        ExplanationHistoryErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry,
        ),
      );
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
          final filtered = await _searchExplanationHistoryUseCase(query);
          final grouped = _groupExplanationsByPdf(filtered);
          emit(
            ExplanationHistoryLoadedState(
              groupedExplanations: grouped,
              allExplanations: currentState.allExplanations,
              searchQuery: query,
            ),
          );
        } catch (e, st) {
          GetIt.I<Talker>().handle(e, st);
          final error = e is AppError ? e : const UnknownError();
          emit(
            ExplanationHistoryErrorState(
              errorCode: error.code,
              message: error.message,
              canRetry: error.canRetry,
            ),
          );
        }
      }
    }
  }

  Future<void> _onDeleteHistory(
    DeleteHistoryEvent event,
    Emitter<ExplanationHistoryState> emit,
  ) async {
    try {
      await _deleteExplanationUseCase(event.explanationId);
      add(LoadHistoryEvent());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError ? e : const UnknownError();
      emit(
        ExplanationHistoryErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry,
        ),
      );
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
