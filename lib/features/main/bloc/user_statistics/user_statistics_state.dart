part of 'user_statistics_bloc.dart';

sealed class UserStatisticsState extends Equatable {
  const UserStatisticsState();

  @override
  List<Object> get props => [];
}

final class UserStatisticsLoadingState extends UserStatisticsState {
  const UserStatisticsLoadingState();
}

final class UserStatisticsLoadSuccessState extends UserStatisticsState {
  final UserStatisticModel userStatistics;

  const UserStatisticsLoadSuccessState(this.userStatistics);

  @override
  List<Object> get props => [userStatistics];
}

final class UserStatisticsLoadErrorState extends UserStatisticsState {
  final AppFailure failure;
  const UserStatisticsLoadErrorState(this.failure);

  @override
  List<Object> get props => [failure];
}
