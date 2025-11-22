part of 'user_statistics_bloc.dart';

sealed class UserStatisticsEvent extends Equatable {
  const UserStatisticsEvent();

  @override
  List<Object> get props => [];
}

final class UserStatisticsLoadEvent extends UserStatisticsEvent {
  final String userId;

  const UserStatisticsLoadEvent({required this.userId});
}
