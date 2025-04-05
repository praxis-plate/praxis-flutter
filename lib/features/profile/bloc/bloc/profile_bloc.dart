import 'package:codium/repositories/codium_courses/models/user.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository _userRepository;

  ProfileBloc(this._userRepository) : super(ProfileInitial()) {
    on<ProfileLoadEvent>(_onProfileLoadEvent);
  }

  Future<void> _onProfileLoadEvent(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final user = await _userRepository.getUser();
      emit(ProfileLoadSuccessState(user: user));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(ProfileLoadErrorState(message: e.toString()));
    }
  }
}
