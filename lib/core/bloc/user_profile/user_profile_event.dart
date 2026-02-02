part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class UserProfileLoadEvent extends UserProfileEvent {
  final String userId;

  const UserProfileLoadEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UserProfileRefreshEvent extends UserProfileEvent {
  const UserProfileRefreshEvent();
}

class UserProfileClearEvent extends UserProfileEvent {
  const UserProfileClearEvent();
}
