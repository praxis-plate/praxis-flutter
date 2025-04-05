import 'package:codium/repositories/codium_courses/models/user_statistics.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_statistics_event.dart';
part 'user_statistics_state.dart';

class UserStatisticsBloc
    extends Bloc<UserStatisticsEvent, UserStatisticsState> {
  final IUserRepository userStatisticsRepository;

  UserStatisticsBloc(this.userStatisticsRepository)
      : super(UserStatisticsInitial()) {
    on<UserStatisticsLoadEvent>(_onLoadUserStatistics);
  }

  Future<void> _onLoadUserStatistics(
    UserStatisticsLoadEvent event,
    Emitter<UserStatisticsState> emit,
  ) async {
    emit(UserStatisticsLoadingState());
    try {
      final userStatistics = await userStatisticsRepository.getUserStatistics();
      emit(UserStatisticsLoadSuccessState(userStatistics));
    } catch (e) {
      emit(UserStatisticsLoadErrorState(e.toString()));
    }
  }
}
