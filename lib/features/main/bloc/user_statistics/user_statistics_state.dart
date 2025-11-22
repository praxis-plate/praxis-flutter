part of 'user_statistics_bloc.dart';

sealed class UserStatisticsState extends Equatable {
  const UserStatisticsState();

  @override
  List<Object> get props => [];
}

final class UserStatisticsInitial extends UserStatisticsState {}

final class UserStatisticsLoadingState extends UserStatisticsState {}

final class UserStatisticsLoadSuccessState extends UserStatisticsState {
  final UserStatistics userStatistics;

  const UserStatisticsLoadSuccessState(this.userStatistics);

  @override
  List<Object> get props => [userStatistics];
}

final class UserStatisticsLoadErrorState extends UserStatisticsState {
  final String message;
  const UserStatisticsLoadErrorState(this.message);

  @override
  List<Object> get props => [message];
}
