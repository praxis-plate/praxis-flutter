import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'recommend_event.dart';
part 'recommend_state.dart';

class RecommendBloc extends Bloc<RecommendEvent, RecommendState> {
  final GetRecommendedCoursesUseCase _getRecommendedCoursesUseCase;

  RecommendBloc({
    required GetRecommendedCoursesUseCase getRecommendedCoursesUseCase,
  }) : _getRecommendedCoursesUseCase = getRecommendedCoursesUseCase,
       super(RecommendInitialState()) {
    on<RecommendLoadEvent>(_onRecommendLoadEvent);
  }

  Future<void> _onRecommendLoadEvent(
    RecommendLoadEvent event,
    Emitter<RecommendState> emit,
  ) async {
    emit(RecommendLoadingState());
    try {
      final result = await _getRecommendedCoursesUseCase(event.userId);

      if (result.isSuccess) {
        emit(
          RecommendLoadSuccessState(recommendCourses: result.dataOrNull ?? []),
        );
      } else {
        emit(
          RecommendLoadErrorState(
            failure:
                result.failureOrNull ??
                AppFailure.fromException(
                  StateError('Failed to load recommendations'),
                ),
          ),
        );
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(RecommendLoadErrorState(failure: AppFailure.fromException(e)));
    }
  }
}
