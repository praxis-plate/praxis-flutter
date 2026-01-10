import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'user_statistics_event.dart';
part 'user_statistics_state.dart';

class UserStatisticsBloc
    extends Bloc<UserStatisticsEvent, UserStatisticsState> {
  final GetUserStatisticsUseCase _getUserStatisticsUseCase;

  UserStatisticsBloc({
    required GetUserStatisticsUseCase getUserStatisticsUseCase,
  }) : _getUserStatisticsUseCase = getUserStatisticsUseCase,
       super(const UserStatisticsLoadingState()) {
    on<UserStatisticsLoadEvent>(_onLoadUserStatistics);
  }

  Future<void> _onLoadUserStatistics(
    UserStatisticsLoadEvent event,
    Emitter<UserStatisticsState> emit,
  ) async {
    emit(const UserStatisticsLoadingState());
    try {
      final result = await _getUserStatisticsUseCase(event.userId);

      result.when(
        success: (statistics) {
          if (statistics != null) {
            emit(UserStatisticsLoadSuccessState(statistics));
          } else {
            emit(const UserStatisticsLoadErrorState('Statistics not found'));
          }
        },
        failure: (failure) {
          emit(UserStatisticsLoadErrorState(failure.message));
        },
      );
    } catch (e, st) {
      emit(UserStatisticsLoadErrorState(e.toString()));
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
