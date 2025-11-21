import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/exceptions/app_exception.dart';
import 'package:codium/core/utils/retry_logic.dart';
import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/usecases/explain_text_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
    emit(
      AiExplanationLoadingState(
        selectedText: event.selectedText,
        pageNumber: event.pageNumber,
      ),
    );

    try {
      final explanation = await RetryLogic.retry(
        operation: () => _explainTextUseCase.execute(
          selectedText: event.selectedText,
          context: event.context,
          pdfBookId: event.pdfBookId,
          pageNumber: event.pageNumber,
        ),
        maxAttempts: 2,
        shouldRetry: (e) => e is NetworkError && e is! RateLimitError,
      );

      emit(AiExplanationLoadedState(explanation: explanation));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      final error = e is AppError ? e : const UnknownError();

      final isOffline =
          error.code == AppErrorCode.networkNoInternet ||
          error.code == AppErrorCode.networkTimeout;

      emit(
        AiExplanationErrorState(
          errorCode: error.code,
          message: error.message,
          canRetry: error.canRetry && error is! RateLimitError,
          isOffline: isOffline,
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
}
