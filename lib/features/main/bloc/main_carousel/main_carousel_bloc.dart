import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_carousel_event.dart';
part 'main_carousel_state.dart';

class MainCarouselBloc extends Bloc<MainCarouselEvent, MainCarouselState> {
  final GetMainCarouselCoursesUseCase _getMainCarouselCoursesUseCase;

  MainCarouselBloc({
    required GetMainCarouselCoursesUseCase getMainCarouselCoursesUseCase,
  }) : _getMainCarouselCoursesUseCase = getMainCarouselCoursesUseCase,
       super(MainCarouselInitialState()) {
    on<MainCarouselLoadEvent>(_onCarouselLoadCourses);
  }

  Future<void> _onCarouselLoadCourses(
    MainCarouselLoadEvent event,
    Emitter<MainCarouselState> emit,
  ) async {
    emit(MainCarouselLoadingState());
    try {
      final result = await _getMainCarouselCoursesUseCase();

      if (result.isSuccess) {
        emit(MainCarouselLoadSuccessState(result.dataOrNull ?? []));
      } else {
        emit(
          MainCarouselLoadErrorState(
            result.failureOrNull?.message ?? 'Unknown error',
          ),
        );
      }
    } catch (e) {
      emit(MainCarouselLoadErrorState(e.toString()));
    }
  }
}
