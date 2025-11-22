import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final GetCourseDetailUseCase _getCourseDetailUseCase;

  CourseDetailBloc({required GetCourseDetailUseCase getCourseDetailUseCase})
    : _getCourseDetailUseCase = getCourseDetailUseCase,
      super(CourseDetailInitialState()) {
    on<CourseDetailLoadEvent>(_onLoadCourseDetail);
  }

  Future<void> _onLoadCourseDetail(
    CourseDetailLoadEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(CourseDetailLoadingState());
    try {
      GetIt.I<Talker>().log('event.courseId: ${event.courseId}');
      final course = await _getCourseDetailUseCase(event.courseId);
      emit(CourseDetailLoadSuccessState(course: course));
    } catch (e) {
      emit(CourseDetailLoadErrorState(e.toString()));
    }
  }
}
