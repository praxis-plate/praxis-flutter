import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/features/learning/bloc/learning/learning_bloc.dart';
import 'package:praxis/features/learning/widgets/empty_learning_state.dart';
import 'package:praxis/features/learning/widgets/enrolled_courses_list.dart';
import 'package:praxis/features/main/main.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  Future<void> _refresh(BuildContext context, String userId) async {
    context.read<LearningBloc>().add(LearningLoadEvent(userId: userId));
  }

  Future<void> _continueLearning(
    BuildContext context,
    CourseModel course,
    String userId,
  ) async {
    final route = await context.read<LearningBloc>().resolveContinueRoute(
      userId: userId,
      course: course,
    );

    if (!context.mounted) {
      return;
    }

    context.push(route);
  }

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
            LearningLoadSuccessState() => RefreshIndicator(
              onRefresh: () => _refresh(context, userId),
              child: state.enrolledCourses.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: const [EmptyLearningState()],
                    )
                  : EnrolledCoursesList(
                      courses: state.enrolledCourses,
                      courseStatistics: state.courseStatistics,
                      onContinue: (course) =>
                          _continueLearning(context, course, userId),
                    ),
            ),
          },
        ),
      ),
    );
  }
}
