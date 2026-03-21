import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:praxis/features/course_details/widgets/widgets.dart';
import 'package:praxis/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailScreen extends StatelessWidget {
  final int courseId;

  const CourseDetailScreen({
    required this.userProfile,
    required this.courseId,
    super.key,
  });

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoursePurchasingBloc, CoursePurchasingState>(
      listenWhen: (previous, current) =>
          current is CoursePurchasingLoadSuccessState &&
          current.courseId == courseId,
      listener: (context, state) {
        context.read<CourseDetailBloc>().add(
          CourseDetailLoadEvent(courseId: courseId, userId: userProfile.id),
        );
      },
      child: const Scaffold(body: CourseBody()),
    );
  }
}
