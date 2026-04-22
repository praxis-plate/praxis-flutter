import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:praxis/features/course_details/widgets/course_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseBody extends StatelessWidget {
  const CourseBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailBloc, CourseDetailState>(
      builder: (context, state) {
        return switch (state) {
          CourseDetailLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
          CourseDetailLoadErrorState(:final failure) => ErrorScreen(
            message: failure.code.localizedMessage(context),
          ),
          CourseDetailLoadSuccessState(:final course, :final isPurchased) =>
            CourseDetail(course: course, isPurchased: isPurchased),
        };
      },
    );
  }
}
