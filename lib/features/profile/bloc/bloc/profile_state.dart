part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadErrorState extends ProfileState {
  final String message;

  const ProfileLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ProfileLoadSuccessState extends ProfileState {
  final UserProfileModel user;
  final int coinBalance;
  final int totalCoursesCompleted;
  final int totalLessonsCompleted;
  final List<AchievementModel> achievements;
  final int currentStreak;

  const ProfileLoadSuccessState({
    required this.user,
    required this.coinBalance,
    required this.totalCoursesCompleted,
    required this.totalLessonsCompleted,
    required this.achievements,
    required this.currentStreak,
  });

  @override
  List<Object> get props => [
    user,
    coinBalance,
    totalCoursesCompleted,
    totalLessonsCompleted,
    achievements,
    currentStreak,
  ];
}
