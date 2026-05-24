import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/features/course_learning/bloc/bloc.dart';
import 'package:praxis/features/course_learning/widgets/course_progress_bar.dart';
import 'package:praxis/s.dart';

class CourseLearningProgress extends StatelessWidget {
  const CourseLearningProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<CourseLearningBloc, CourseLearningState>(
      builder: (context, state) {
        if (state is! CourseLearningLoaded) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    s.lessonsCompleted(
                      state.statistics.solvedTasks,
                      state.statistics.totalTasks,
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    s.courseProgressPercent(state.statistics.progress.round()),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              CourseProgressBar(userCourseStatistics: state.statistics),
            ],
          ),
        );
      },
    );
  }
}
