import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course_content/course_content_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final CheckCourseEnrollmentUseCase _checkCourseEnrollmentUseCase;

  CourseDetailBloc({
    required GetCourseDetailUseCase getCourseDetailUseCase,
    required CheckCourseEnrollmentUseCase checkCourseEnrollmentUseCase,
  }) : _getCourseDetailUseCase = getCourseDetailUseCase,
       _checkCourseEnrollmentUseCase = checkCourseEnrollmentUseCase,
       super(CourseDetailLoadingState()) {
    on<CourseDetailLoadEvent>(_onLoadCourseDetail);
  }

  Future<void> _onLoadCourseDetail(
    CourseDetailLoadEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(CourseDetailLoadingState());
    try {
      final courseResult = await _getCourseDetailUseCase(event.courseId);

      if (courseResult.isFailure) {
        emit(CourseDetailLoadErrorState(courseResult.failureOrNull!.message));
        return;
      }

      final course = courseResult.dataOrNull;
      if (course == null) {
        emit(const CourseDetailLoadErrorState('Course not found'));
        return;
      }

      final enrollmentResult = await _checkCourseEnrollmentUseCase(
        userId: event.userId,
        courseId: event.courseId,
      );

      final isPurchased = enrollmentResult.dataOrNull ?? false;

      emit(
        CourseDetailLoadSuccessState(course: course, isPurchased: isPurchased),
      );
    } catch (e) {
      emit(CourseDetailLoadErrorState(e.toString()));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
