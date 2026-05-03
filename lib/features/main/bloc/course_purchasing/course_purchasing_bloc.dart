import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/usecases/usecases.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_purchasing_event.dart';
part 'course_purchasing_state.dart';

class CoursePurchasingBloc
    extends Bloc<CoursePurchasingEvent, CoursePurchasingState> {
  final PurchaseCourseUseCase _purchaseCourseUseCase;
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final GetUserStatisticsUseCase _getUserStatisticsUseCase;

  CoursePurchasingBloc({
    required PurchaseCourseUseCase purchaseCourseUseCase,
    required GetCourseDetailUseCase getCourseDetailUseCase,
    required GetUserStatisticsUseCase getUserStatisticsUseCase,
  }) : _purchaseCourseUseCase = purchaseCourseUseCase,
       _getCourseDetailUseCase = getCourseDetailUseCase,
       _getUserStatisticsUseCase = getUserStatisticsUseCase,
       super(CoursePurchasingInitialState()) {
    on<CoursePurchasingRequestEvent>(_onPurchasingRequestEvent);
  }

  Future<void> _onPurchasingRequestEvent(
    CoursePurchasingRequestEvent event,
    Emitter<CoursePurchasingState> emit,
  ) async {
    final talker = GetIt.I<Talker>();

    emit(CoursePurchasingLoadingState(event.courseId));

    try {
      final result = await _purchaseCourseUseCase(event.userId, event.courseId);

      if (result.isSuccess) {
        emit(CoursePurchasingLoadSuccessState(event.courseId));
        return;
      }

      final failure = result.failureOrNull!;
      if (failure.code == AppErrorCode.insufficientBalance) {
        await _emitInsufficientBalanceState(event, emit);
        return;
      }

      emit(CoursePurchasingLoadErrorState(event.courseId, failure));
    } catch (e, st) {
      talker.handle(e, st);
      emit(
        CoursePurchasingLoadErrorState(
          event.courseId,
          AppFailure.fromException(e),
        ),
      );
    }
  }

  Future<void> _emitInsufficientBalanceState(
    CoursePurchasingRequestEvent event,
    Emitter<CoursePurchasingState> emit,
  ) async {
    final courseResult = await _getCourseDetailUseCase(event.courseId);
    if (courseResult.isFailure || courseResult.dataOrNull == null) {
      emit(_coursePurchaseUnavailableState(event.courseId));
      return;
    }

    final statisticsResult = await _getUserStatisticsUseCase(event.userId);
    if (statisticsResult.isFailure || statisticsResult.dataOrNull == null) {
      emit(_coursePurchaseUnavailableState(event.courseId));
      return;
    }

    emit(
      CoursePurchasingInsufficientBalanceState(
        event.courseId,
        requiredMoney: courseResult.dataOrNull!.priceInCoins,
        availableMoney: statisticsResult.dataOrNull!.balance.amount,
      ),
    );
  }

  CoursePurchasingLoadErrorState _coursePurchaseUnavailableState(int courseId) {
    return CoursePurchasingLoadErrorState(
      courseId,
      const AppFailure(
        code: AppErrorCode.coursePurchaseUnavailable,
        message: 'Course purchase is unavailable',
        canRetry: true,
      ),
    );
  }
}
