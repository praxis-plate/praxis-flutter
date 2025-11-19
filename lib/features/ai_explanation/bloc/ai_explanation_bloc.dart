import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/usecases/explain_text_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ai_explanation_event.dart';
part 'ai_explanation_state.dart';

class AiExplanationBloc extends Bloc<AiExplanationEvent, AiExplanationState> {
  final ExplainTextUseCase _explainTextUseCase;

  AiExplanationBloc({required ExplainTextUseCase explainTextUseCase})
    : _explainTextUseCase = explainTextUseCase,
      super(AiExplanationInitialState()) {
    on<RequestExplanationEvent>(_onRequestExplanation);
    on<RetryExplanationEvent>(_onRetryExplanation);
  }

  Future<void> _onRequestExplanation(
    RequestExplanationEvent event,
    Emitter<AiExplanationState> emit,
  ) async {
    emit(AiExplanationLoadingState(selectedText: event.selectedText));

    try {
      final explanation = await _explainTextUseCase.execute(
        selectedText: event.selectedText,
        context: event.context,
        pdfBookId: event.pdfBookId,
        pageNumber: event.pageNumber,
      );

      emit(AiExplanationLoadedState(explanation: explanation));
    } catch (e) {
      final errorMessage = e.toString();
      final isNetworkError =
          errorMessage.contains('connection') ||
          errorMessage.contains('network') ||
          errorMessage.contains('offline');
      final isRateLimitError =
          errorMessage.contains('rate limit') ||
          errorMessage.contains('Rate limit');

      emit(
        AiExplanationErrorState(
          message: _formatErrorMessage(errorMessage),
          canRetry: !isRateLimitError,
          isOffline: isNetworkError,
        ),
      );
    }
  }

  Future<void> _onRetryExplanation(
    RetryExplanationEvent event,
    Emitter<AiExplanationState> emit,
  ) async {
    if (event.lastRequest != null) {
      add(event.lastRequest!);
    }
  }

  String _formatErrorMessage(String error) {
    if (error.contains('Rate limit') || error.contains('rate limit')) {
      return 'AI service is temporarily unavailable. Please try again in a few moments.';
    }
    if (error.contains('connection') ||
        error.contains('network') ||
        error.contains('offline')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (error.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    return 'Failed to generate explanation. Please try again.';
  }
}
