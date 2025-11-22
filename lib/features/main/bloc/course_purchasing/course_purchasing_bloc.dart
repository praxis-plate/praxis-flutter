import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_purchasing_event.dart';
part 'course_purchasing_state.dart';

class CoursePurchasingBloc
    extends Bloc<CoursePurchasingEvent, CoursePurchasingState> {
  final PurchaseCourseUseCase _purchaseCourseUseCase;
  final AuthBloc _authBloc;

  CoursePurchasingBloc({
    required AuthBloc authBloc,
    required PurchaseCourseUseCase purchaseCourseUseCase,
  }) : _authBloc = authBloc,
       _purchaseCourseUseCase = purchaseCourseUseCase,
       super(CoursePurchasingInitialState()) {
    on<CoursePurchasingRequestEvent>(_onPurchasingRequestEvent);
  }

  Future<void> _onPurchasingRequestEvent(
    CoursePurchasingRequestEvent event,
    Emitter<CoursePurchasingState> emit,
  ) async {
    emit(CoursePurchasingLoadingState(event.courseId));
    try {
      final updatedUser = await _purchaseCourseUseCase(event.courseId);
      _authBloc.add(AuthUpdateUserEvent(updatedUser: updatedUser));
      emit(CoursePurchasingLoadSuccessState(event.courseId));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(CoursePurchasingLoadErrorState(event.courseId, e.toString()));
    }
  }
}
