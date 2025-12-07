import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/usecases/usecases.dart';
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
      final result = await _explainTextUseCase();

      if (result.isSuccess) {
        final explanations = result.dataOrNull ?? [];
        if (explanations.isNotEmpty) {
          final explanation = Explanation(
            id: explanations.first.id.toString(),
            pdfBookId: event.pdfBookId.toString(),
            pageNumber: event.pageNumber,
            selectedText: event.selectedText,
            explanation: 'Explanation text',
            sources: const [],
            createdAt: DateTime.now(),
          );
          emit(AiExplanationLoadedState(explanation: explanation));
        } else {
          emit(
            const AiExplanationErrorState(
              errorCode: AppErrorCode.unknown,
              message: 'No explanations found',
              canRetry: true,
              isOffline: false,
            ),
          );
        }
      } else {
        final failure = result.failureOrNull!;
        emit(
          AiExplanationErrorState(
            errorCode: failure.code,
            message: failure.message,
            canRetry: failure.canRetry,
            isOffline: false,
          ),
        );
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(
        const AiExplanationErrorState(
          errorCode: AppErrorCode.unknown,
          message: 'Failed to get explanation',
          canRetry: true,
          isOffline: false,
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
