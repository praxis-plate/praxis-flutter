import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_purchasing_event.dart';
part 'course_purchasing_state.dart';

class CoursePurchasingBloc
    extends Bloc<CoursePurchasingEvent, CoursePurchasingState> {
  final PurchaseCourseUseCase _purchaseCourseUseCase;

  CoursePurchasingBloc({required PurchaseCourseUseCase purchaseCourseUseCase})
    : _purchaseCourseUseCase = purchaseCourseUseCase,
      super(CoursePurchasingInitialState()) {
    on<CoursePurchasingRequestEvent>(_onPurchasingRequestEvent);
  }

  Future<void> _onPurchasingRequestEvent(
    CoursePurchasingRequestEvent event,
    Emitter<CoursePurchasingState> emit,
  ) async {
    final talker = GetIt.I<Talker>();
    talker.info(
      '💳 Starting course purchase: userId=${event.userId}, courseId=${event.courseId}',
    );

    emit(CoursePurchasingLoadingState(event.courseId));

    try {
      talker.debug('Calling PurchaseCourseUseCase...');
      final result = await _purchaseCourseUseCase(event.userId, event.courseId);

      result.when(
        success: (_) {
          talker.info('✅ Course purchased successfully: ${event.courseId}');
          emit(CoursePurchasingLoadSuccessState(event.courseId));
        },
        failure: (failure) {
          if (failure.code == AppErrorCode.insufficientBalance) {
            talker.warning('💰 Insufficient balance: ${failure.message}');
            emit(
              CoursePurchasingInsufficientBalanceState(
                event.courseId,
                required: 0,
                available: 0,
              ),
            );
            return;
          }

          talker.warning('⚠️ Course purchase failed: ${failure.message}');
          emit(CoursePurchasingLoadErrorState(event.courseId, failure));
        },
      );
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
}
