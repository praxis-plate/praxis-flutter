part of 'ai_explanation_bloc.dart';

sealed class AiExplanationEvent extends Equatable {
  const AiExplanationEvent();

  @override
  List<Object?> get props => [];
}

class RequestExplanationEvent extends AiExplanationEvent {
  final String selectedText;
  final String context;
  final String pdfBookId;
  final int pageNumber;

  const RequestExplanationEvent({
    required this.selectedText,
    required this.context,
    required this.pdfBookId,
    required this.pageNumber,
  });

  @override
  List<Object?> get props => [selectedText, context, pdfBookId, pageNumber];
}

class RetryExplanationEvent extends AiExplanationEvent {
  final RequestExplanationEvent? lastRequest;

  const RetryExplanationEvent({this.lastRequest});

  @override
  List<Object?> get props => [lastRequest];
}
