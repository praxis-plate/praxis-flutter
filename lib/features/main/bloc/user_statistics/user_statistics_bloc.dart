import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/domain/usecases/usecases.dart';
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
            emit(
              const UserStatisticsLoadErrorState(
                AppFailure(code: AppErrorCode.apiNotFound, message: ''),
              ),
            );
          }
        },
        failure: (failure) {
          GetIt.I<Talker>().error(failure.code);
          emit(UserStatisticsLoadErrorState(failure));
        },
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(UserStatisticsLoadErrorState(AppFailure.fromException(e)));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
