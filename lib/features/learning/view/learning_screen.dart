import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/learning/bloc/learning/learning_bloc.dart';
import 'package:praxis/features/learning/widgets/empty_learning_state.dart';
import 'package:praxis/features/learning/widgets/enrolled_courses_list.dart';
import 'package:praxis/features/main/main.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final userId = UserScope.of(context).id;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.learningTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        titleSpacing: 16,
      ),
      body: BlocListener<CoursePurchasingBloc, CoursePurchasingState>(
        listenWhen: (previous, current) =>
            previous is CoursePurchasingLoadingState &&
            current is CoursePurchasingLoadSuccessState,
        listener: (context, state) {
          if (state is! CoursePurchasingLoadSuccessState) {
            return;
          }

          context.read<LearningBloc>().add(LearningLoadEvent(userId: userId));
        },
        child: BlocBuilder<LearningBloc, LearningState>(
          builder: (context, state) => switch (state) {
            LearningLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            LearningLoadErrorState(:final failure) => ErrorScreen(
              message: failure.code.localizedMessage(context),
            ),
            LearningLoadSuccessState() =>
              state.enrolledCourses.isEmpty
                  ? const EmptyLearningState()
                  : EnrolledCoursesList(
                      courses: state.enrolledCourses,
                      courseStatistics: state.courseStatistics,
                    ),
          },
        ),
      ),
    );
  }
}
