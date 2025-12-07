import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';
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
      final result = await _getExplanationHistoryUseCase();

      if (result.isSuccess) {
        final explanations = result.dataOrNull ?? [];
        final grouped = _groupExplanationsByPdf(explanations);
        emit(
          ExplanationHistoryLoadedState(
            groupedExplanations: grouped,
            allExplanations: explanations,
          ),
        );
      } else {
        emit(
          ExplanationHistoryErrorState(
            errorCode: result.failureOrNull?.code ?? AppErrorCode.unknown,
            message: result.failureOrNull?.message ?? 'Unknown error',
            canRetry: result.failureOrNull?.canRetry ?? true,
          ),
        );
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(
        const ExplanationHistoryErrorState(
          errorCode: AppErrorCode.unknown,
          message: 'Failed to load history',
          canRetry: true,
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
          final result = await _searchExplanationHistoryUseCase(query);

          if (result.isSuccess) {
            final filtered = result.dataOrNull ?? [];
            final grouped = _groupExplanationsByPdf(filtered);
            emit(
              ExplanationHistoryLoadedState(
                groupedExplanations: grouped,
                allExplanations: currentState.allExplanations,
                searchQuery: query,
              ),
            );
          }
        } catch (e, st) {
          GetIt.I<Talker>().handle(e, st);
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
    }
  }

  Map<int, List<ExplanationModel>> _groupExplanationsByPdf(
    List<ExplanationModel> explanations,
  ) {
    final Map<int, List<ExplanationModel>> grouped = {};
    for (final explanation in explanations) {
      if (!grouped.containsKey(explanation.pdfBookId)) {
        grouped[explanation.pdfBookId] = [];
      }
      grouped[explanation.pdfBookId]!.add(explanation);
    }
    return grouped;
  }
}
