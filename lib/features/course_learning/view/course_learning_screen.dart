import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/features.dart';
import 'package:praxis/s.dart';

class CourseLearningScreen extends StatelessWidget {
  const CourseLearningScreen({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context) {
    final userId = UserScope.of(context, listen: false).id;

    return BlocProvider(
      create: (context) =>
          GetIt.I<CourseLearningBloc>()
            ..add(LoadCourseLearning(courseId: courseId, userId: userId)),
      child: _CourseLearningScaffold(courseId: courseId, userId: userId),
    );
  }
}

class _CourseLearningScaffold extends StatelessWidget {
  const _CourseLearningScaffold({required this.courseId, required this.userId});

  final int courseId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: const CourseLearningAppBarTitle(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () => context.push('/course/$courseId'),
              tooltip: s.courseDetailsTitle,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundColor: theme.colorScheme.primary,
              ),
              icon: const Icon(Icons.info_outline),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: CourseLearningProgress(),
        ),
      ),
      body: BlocBuilder<CourseLearningBloc, CourseLearningState>(
        builder: (context, state) {
          if (state is CourseLearningLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseLearningError) {
            return ErrorScreen(
              message: state.failure.code.localizedMessage(context),
              onRetry: () {
                context.read<CourseLearningBloc>().add(const RefreshProgress());
              },
            );
          }

          if (state is! CourseLearningLoaded) {
            return const SizedBox.shrink();
          }

          final completedLessonIds = state.lessonProgress
              .where((progress) => progress.isCompleted)
              .map((progress) => progress.lessonId)
              .toSet();

          return Column(
            children: [
              if (state.courseAssessment != null)
                CourseAssessmentCard(assessment: state.courseAssessment!),
              Expanded(
                child: LessonsList(
                  courseId: state.course.id,
                  completedLessonIds: completedLessonIds,
                  userId: userId,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
