import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis_client/praxis_client.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final CheckCourseEnrollmentUseCase _checkCourseEnrollmentUseCase;
  final GetCourseTableOfContentsUseCase _getTableOfContentsUseCase;

  CourseDetailBloc({
    required GetCourseDetailUseCase getCourseDetailUseCase,
    required CheckCourseEnrollmentUseCase checkCourseEnrollmentUseCase,
    required GetCourseTableOfContentsUseCase getTableOfContentsUseCase,
  }) : _getCourseDetailUseCase = getCourseDetailUseCase,
       _checkCourseEnrollmentUseCase = checkCourseEnrollmentUseCase,
       _getTableOfContentsUseCase = getTableOfContentsUseCase,
       super(CourseDetailLoadingState()) {
    on<CourseDetailLoadEvent>(_onLoadCourseDetail);
  }

  Future<void> _onLoadCourseDetail(
    CourseDetailLoadEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(CourseDetailLoadingState());
    try {
      GetIt.I<Talker>().log(
        'Loading course detail: courseId=${event.courseId}, userId=${event.userId}',
      );

      final courseResult = await _getCourseDetailUseCase(event.courseId);

      if (!courseResult.isSuccess) {
        emit(
          CourseDetailLoadErrorState(
            courseResult.failureOrNull?.message ?? 'Unknown error',
          ),
        );
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

      GetIt.I<Talker>().info(
        'Course enrollment status: isPurchased=$isPurchased',
      );

      final tableOfContentsResult = await _getTableOfContentsUseCase(
        event.courseId,
      );
      final tableOfContents = tableOfContentsResult.dataOrNull;

      emit(
        CourseDetailLoadSuccessState(
          course: course,
          isPurchased: isPurchased,
          tableOfContents: tableOfContents,
        ),
      );
    } catch (e) {
      emit(CourseDetailLoadErrorState(e.toString()));
    }
  }
}
