import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/features/lesson/bloc/bloc.dart';
import 'package:praxis/s.dart';

class LessonContentTitle extends StatelessWidget {
  const LessonContentTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<LessonContentBloc, LessonContentState>(
      builder: (context, state) {
        final title = switch (state) {
          LessonContentLoaded(:final lesson) => lesson.title,
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
