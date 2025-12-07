import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'learning_event.dart';
part 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final GetLearningDataUseCase _getLearningDataUseCase;
  final GetEnrolledCoursesUseCase _getEnrolledCoursesUseCase;

  LearningBloc({
    required GetLearningDataUseCase getLearningDataUseCase,
    required GetEnrolledCoursesUseCase getEnrolledCoursesUseCase,
  }) : _getLearningDataUseCase = getLearningDataUseCase,
       _getEnrolledCoursesUseCase = getEnrolledCoursesUseCase,
       super(LearningInitialState()) {
    on<LearningLoadEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LearningLoadEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoadingState());
    try {
      final userId = int.parse(event.userId);

      final statisticsResult = await _getLearningDataUseCase(userId);
      final coursesResult = await _getEnrolledCoursesUseCase(userId);

      if (statisticsResult.isFailure) {
        emit(
          LearningLoadErrorState(
            message: statisticsResult.failureOrNull!.message,
          ),
        );
        return;
      }

      if (coursesResult.isFailure) {
        emit(
          LearningLoadErrorState(message: coursesResult.failureOrNull!.message),
        );
        return;
      }

      emit(
        LearningLoadSuccessState(
          activityData: const [],
          enrolledCourses: coursesResult.dataOrNull ?? [],
        ),
      );
    } catch (e) {
      GetIt.I<Talker>().error('LearningBloc error: $e');
      final errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Ошибка загрузки данных';
      emit(LearningLoadErrorState(message: errorMessage));
    }
  }
}
