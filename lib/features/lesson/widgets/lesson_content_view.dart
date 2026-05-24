import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/core/bloc/achievement_notification/achievement_notification_cubit.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/lesson/bloc/bloc.dart';
import 'package:praxis/features/lesson/widgets/lesson_completion_dialog.dart';
import 'package:praxis/features/lesson/widgets/lesson_content_body.dart';
import 'package:praxis/features/lesson/widgets/lesson_content_title.dart';

class LessonContentView extends StatelessWidget {
  const LessonContentView({
    super.key,
    required this.lessonId,
    required this.courseId,
  });

  final String lessonId;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LessonContentBloc, LessonContentState>(
      listener: (context, state) {
        if (state is! LessonContentCompleted) {
          return;
        }

        for (final achievement in state.achievements) {
          context.read<AchievementNotificationCubit>().showAchievement(
            achievement,
          );
        }

        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => LessonCompletionDialog(state: state),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 16,
          title: const LessonContentTitle(),
        ),
        body: BlocBuilder<LessonContentBloc, LessonContentState>(
          builder: (context, state) {
            if (state is LessonContentLoading ||
                state is LessonContentCompleting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LessonContentError) {
              return ErrorScreen(
                message: state.failure.code.localizedMessage(context),
                onRetry: () {
                  context.read<LessonContentBloc>().add(
                    LoadLessonContent(
                      lessonId: lessonId,
                      userId: '',
                      courseId: courseId,
                    ),
                  );
                },
              );
            }

            if (state is LessonContentLoaded) {
              return LessonContentBody(
                lesson: state.lesson,
                courseId: courseId,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
