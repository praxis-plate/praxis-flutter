import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/features/course_learning/bloc/bloc.dart';
import 'package:praxis/s.dart';

class CourseLearningAppBarTitle extends StatelessWidget {
  const CourseLearningAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<CourseLearningBloc, CourseLearningState>(
      builder: (context, state) {
        final title = switch (state) {
          CourseLearningLoaded(:final course) => course.title,
          _ => s.loading,
        };

        return Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }
}
