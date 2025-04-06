part of 'learning_bloc.dart';

sealed class LearningState extends Equatable {
  const LearningState();

  @override
  List<Object> get props => [];
}

final class LearningInitialState extends LearningState {}

final class LearningLoadingState extends LearningState {}

final class LearningLoadSuccessState extends LearningState {
  final LearningData learningData;

  const LearningLoadSuccessState({
    required this.learningData,
  });

  @override
  List<Object> get props => [learningData];
}

final class LearningLoadErrorState extends LearningState {
  final String message;

  const LearningLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
