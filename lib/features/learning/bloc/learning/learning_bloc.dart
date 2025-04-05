import 'package:codium/repositories/codium_courses/models/activity_cell.dart';
import 'package:codium/repositories/codium_courses/models/user_course_statistics.dart';
import 'package:codium/repositories/codium_courses/models/user_statistics.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'learning_event.dart';
part 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final IUserRepository userRepository;

  LearningBloc(this.userRepository) : super(LearningInitialState()) {
    on<LearningEvent>(_onLoad);
  }

  Future<void> _onLoad(LearningEvent event, Emitter<LearningState> emit) async {
    emit(LearningLoadingState());
    try {
      final activityCells = await userRepository.getUserActivityCells();
      final userStatistics = await userRepository.getUserStatistics();
      final addedCoursesStatistics =
          await userRepository.getUserAddedCoursesStatistics();
      final passedCoursesStatistics =
          await userRepository.getUserPassedCoursesStatistics();
      emit(
        LearningLoadSuccessState(
          activityCells: activityCells,
          userStatistics: userStatistics,
          addedCoursesStatistics: addedCoursesStatistics,
          passedCoursesStatistics: passedCoursesStatistics,
        ),
      );
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);
      emit(LearningLoadErrorState(message: e.toString()));
    }
  }
}
