part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitialState extends UserProfileState {
  const UserProfileInitialState();
}

class UserProfileLoadingState extends UserProfileState {
  const UserProfileLoadingState();
}

class UserProfileLoadedState extends UserProfileState {
  final UserProfileModel profile;
  final Money balance;
  final List<int> purchasedCourseIds;
  final int currentStreak;
  final int maxStreak;

  const UserProfileLoadedState({
    required this.profile,
    required this.balance,
    required this.purchasedCourseIds,
    required this.currentStreak,
    required this.maxStreak,
  });

  @override
  List<Object> get props => [
    profile,
    balance,
    purchasedCourseIds,
    currentStreak,
    maxStreak,
  ];
}

class UserProfileErrorState extends UserProfileState {
  final AppFailure failure;

  const UserProfileErrorState(this.failure);

  @override
  List<Object> get props => [failure];
}
