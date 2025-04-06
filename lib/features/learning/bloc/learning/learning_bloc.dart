import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/usecases/get_learning_data_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'learning_event.dart';
part 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final GetLearningDataUseCase _getLearningDataUseCase;

  LearningBloc({
    required GetLearningDataUseCase getLearningDataUseCase,
  })  : _getLearningDataUseCase = getLearningDataUseCase,
        super(LearningInitialState()) {
    on<LearningLoadEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LearningLoadEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoadingState());
    try {
      final learningData = await _getLearningDataUseCase.execute(event.userId);

      emit(
        LearningLoadSuccessState(
          learningData: learningData,
        ),
      );
    } catch (e) {
      GetIt.I<Talker>().error('LearningBloc error: ${e.toString()}');
      emit(LearningLoadErrorState(message: e.toString()));
    }
  }
}
