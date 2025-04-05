import 'package:codium/repositories/codium_courses/models/user_course_statistics.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'recommend_event.dart';
part 'recommend_state.dart';

class RecommendBloc extends Bloc<RecommendEvent, RecommendState> {
  final IUserRepository userRepository;

  RecommendBloc(this.userRepository) : super(RecommendInitialState()) {
    on<RecommendLoadEvent>(_onRecommendLoadEvent);
  }

  Future<void> _onRecommendLoadEvent(
    RecommendLoadEvent event,
    Emitter<RecommendState> emit,
  ) async {
    emit(RecommendLoadingState());
    try {
      final recommendCoursesStatistics =
          await userRepository.getUserPassedCoursesStatistics();
      emit(
        RecommendLoadSuccessState(
          recommendCoursesStatistics: recommendCoursesStatistics,
        ),
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(RecommendLoadErrorState(message: e.toString()));
    }
  }
}
