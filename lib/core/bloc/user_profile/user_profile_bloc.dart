import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/money.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:praxis/domain/usecases/user/get_full_user_profile_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetFullUserProfileUseCase _getFullUserProfileUseCase;
  String? _currentUserId;

  UserProfileBloc({
    required GetFullUserProfileUseCase getFullUserProfileUseCase,
  }) : _getFullUserProfileUseCase = getFullUserProfileUseCase,
       super(const UserProfileInitialState()) {
    on<UserProfileLoadEvent>(_onLoad);
    on<UserProfileRefreshEvent>(_onRefresh);
    on<UserProfileClearEvent>(_onClear);
  }

  Future<void> _onLoad(
    UserProfileLoadEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(const UserProfileLoadingState());
      _currentUserId = event.userId;

      final userProfile = UserProfileModel(
        id: event.userId,
        email: '',
        name: '',
        createdAt: DateTime.now(),
      );

      final result = await _getFullUserProfileUseCase(userProfile);

      result.when(
        success: (fullProfile) {
          emit(
            UserProfileLoadedState(
              profile: fullProfile.profile,
              balance: fullProfile.balance,
              purchasedCourseIds: fullProfile.purchasedCourseIds,
              currentStreak: fullProfile.currentStreak,
              maxStreak: fullProfile.maxStreak,
            ),
          );
        },
        failure: (failure) {
          emit(UserProfileErrorState(failure));
        },
      );
    } catch (e, st) {
      emit(UserProfileErrorState(AppFailure.fromException(e)));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onRefresh(
    UserProfileRefreshEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    if (_currentUserId == null) return;

    try {
      final userProfile = UserProfileModel(
        id: _currentUserId!,
        email: '',
        name: '',
        createdAt: DateTime.now(),
      );

      final result = await _getFullUserProfileUseCase(userProfile);

      result.when(
        success: (fullProfile) {
          emit(
            UserProfileLoadedState(
              profile: fullProfile.profile,
              balance: fullProfile.balance,
              purchasedCourseIds: fullProfile.purchasedCourseIds,
              currentStreak: fullProfile.currentStreak,
              maxStreak: fullProfile.maxStreak,
            ),
          );
        },
        failure: (failure) {
          emit(UserProfileErrorState(failure));
        },
      );
    } catch (e, st) {
      emit(UserProfileErrorState(AppFailure.fromException(e)));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onClear(
    UserProfileClearEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    _currentUserId = null;
    emit(const UserProfileInitialState());
  }
}
