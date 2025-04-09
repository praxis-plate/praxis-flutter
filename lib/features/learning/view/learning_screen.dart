import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/widgets/activity_table.dart';
import 'package:codium/core/widgets/added_course_card.dart';
import 'package:codium/core/widgets/user_provider.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/features/learning/bloc/learning/learning_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context);

    return BlocProvider(
      create: (context) =>
          GetIt.I<LearningBloc>()..add(LearningLoadEvent(userId: user.id)),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticatedState) {
            context.go('/sign-in');
          }
        },
        child: const _LearningScreenContent(),
      ),
    );
  }
}

class _LearningScreenContent extends StatelessWidget {
  const _LearningScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).learningTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Wrapper(
        child: BlocBuilder<LearningBloc, LearningState>(
          builder: (context, state) {
            if (state is LearningLoadErrorState) {
              return Center(child: Text(state.message));
            }
            if (state is LearningLoadSuccessState) {
              return ListView(
                children: [
                  ActivityTable(
                    userStatistics: state.learningData.userStatistics,
                    activities: state.learningData.activityCells,
                  ),
                  const SizedBox(height: 8),
                  if (state.learningData.addedCoursesStatistics.isNotEmpty)
                    Text(
                      S.of(context).active,
                      style: theme.textTheme.titleSmall,
                    ),
                  if (state.learningData.addedCoursesStatistics.isNotEmpty)
                    const SizedBox(height: 8),
                  ...state.learningData.addedCoursesStatistics.map(
                    (entry) => AddedCourseCard(
                      course: entry.key,
                      userCourseStatistics: entry.value,
                    ),
                  ),
                  if (state.learningData.addedCoursesStatistics.isNotEmpty)
                    const SizedBox(height: 8),
                  if (state.learningData.passedCoursesStatistics.isNotEmpty)
                    Text(
                      S.of(context).passed,
                      style: theme.textTheme.titleSmall,
                    ),
                  if (state.learningData.passedCoursesStatistics.isNotEmpty)
                    const SizedBox(height: 8),
                  ...state.learningData.passedCoursesStatistics.map(
                    (entry) => AddedCourseCard(
                      course: entry.key,
                      userCourseStatistics: entry.value,
                    ),
                  ),
                  if (state.learningData.passedCoursesStatistics.isEmpty &&
                      state.learningData.addedCoursesStatistics.isEmpty)
                    SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(S.of(context).noData),
                      ),
                    ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
