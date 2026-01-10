import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CourseAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return AppBar(
      title: BlocBuilder<CourseDetailBloc, CourseDetailState>(
        builder: (context, state) {
          return Text(
            state is CourseDetailLoadSuccessState
                ? state.course.title
                : s.courseDetailsTitle,
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
