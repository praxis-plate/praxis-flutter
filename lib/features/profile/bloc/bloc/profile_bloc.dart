import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/achievement/achievement_data_model.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final GetUserProfileDataUseCase _getUserProfileDataUseCase;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required GetUserProfileDataUseCase getUserProfileDataUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _getUserProfileDataUseCase = getUserProfileDataUseCase,
       super(ProfileInitial()) {
    on<ProfileLoadEvent>(_onProfileLoadEvent);
  }

  Future<void> _onProfileLoadEvent(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final profileResult = await _getProfileUseCase();
      if (profileResult.isFailure) {
        emit(
          ProfileLoadErrorState(
            message:
                profileResult.failureOrNull?.message ??
                'Failed to load profile',
          ),
        );
        return;
      }

      final profileDataResult = await _getUserProfileDataUseCase(
        profileResult.dataOrNull!.id,
      );
      if (profileDataResult.isFailure) {
        emit(
          ProfileLoadErrorState(
            message:
                profileDataResult.failureOrNull?.message ??
                'Failed to load profile data',
          ),
        );
        return;
      }

      final profileData = profileDataResult.dataOrNull!;
      emit(
        ProfileLoadSuccessState(
          user: profileData.user,
          coinBalance: profileData.coinBalance,
          totalCoursesCompleted: profileData.totalCoursesCompleted,
          totalLessonsCompleted: profileData.totalLessonsCompleted,
          achievements: profileData.achievements,
          currentStreak: profileData.currentStreak,
        ),
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(ProfileLoadErrorState(message: e.toString()));
    }
  }
}
