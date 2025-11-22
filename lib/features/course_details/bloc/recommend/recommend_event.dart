part of 'recommend_bloc.dart';

sealed class RecommendEvent extends Equatable {
  const RecommendEvent();

  @override
  List<Object> get props => [];
}

final class RecommendLoadEvent extends RecommendEvent {
  final String userId;

  const RecommendLoadEvent(this.userId);
}
