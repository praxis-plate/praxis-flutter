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
  final User user;

  const ProfileLoadSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}
