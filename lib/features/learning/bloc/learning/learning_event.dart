part of 'learning_bloc.dart';

sealed class LearningEvent extends Equatable {
  const LearningEvent();

  @override
  List<Object> get props => [];
}

final class LearningLoadEvent extends LearningEvent {
  final int userId;

  const LearningLoadEvent({required this.userId});
}
