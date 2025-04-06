import 'package:codium/domain/models/user_statistics.dart';
import 'package:codium/domain/usecases/get_user_statistics_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'user_statistics_event.dart';
part 'user_statistics_state.dart';

class UserStatisticsBloc
    extends Bloc<UserStatisticsEvent, UserStatisticsState> {
  final GetUserStatisticsUseCase _getUserStatisticsUseCase;

  UserStatisticsBloc(
      {required GetUserStatisticsUseCase getUserStatisticsUseCase,})
      : _getUserStatisticsUseCase = getUserStatisticsUseCase,
        super(UserStatisticsInitial()) {
    on<UserStatisticsLoadEvent>(_onLoadUserStatistics);
  }

  Future<void> _onLoadUserStatistics(
    UserStatisticsLoadEvent event,
    Emitter<UserStatisticsState> emit,
  ) async {
    emit(UserStatisticsLoadingState());
    try {
      final statistics = await _getUserStatisticsUseCase.execute(event.userId);
      emit(UserStatisticsLoadSuccessState(statistics));
    } catch (e, st) {
      emit(UserStatisticsLoadErrorState(e.toString()));
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
