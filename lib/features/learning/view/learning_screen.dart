import 'package:codium/core/widgets/activity_table.dart';
import 'package:codium/core/widgets/added_course_card.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/features/learning/bloc/learning/learning_bloc.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final _learningBloc = LearningBloc(GetIt.I<IUserRepository>());

  @override
  void initState() {
    _learningBloc.add(LearningLoadEvent());
    super.initState();
  }

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
          bloc: _learningBloc,
          builder: (context, state) {
            if (state is LearningLoadErrorState) {
              return Center(child: Text(state.message));
            }
            if (state is LearningLoadSuccessState) {
              return ListView(
                children: [
                  ActivityTable(
                    userStatistics: state.userStatistics,
                    activities: state.activityCells,
                  ),
                  const SizedBox(height: 8),
                  if (state.addedCoursesStatistics.isNotEmpty)
                    Text(
                      S.of(context).active,
                      style: theme.textTheme.titleSmall,
                    ),
                  if (state.addedCoursesStatistics.isNotEmpty)
                    const SizedBox(height: 8),
                  ...state.addedCoursesStatistics
                      .map((e) => AddedCourseCard(courseStatistics: e)),
                  if (state.addedCoursesStatistics.isNotEmpty)
                    const SizedBox(height: 8),
                  if (state.passedCoursesStatistics.isNotEmpty)
                    Text(
                      S.of(context).passed,
                      style: theme.textTheme.titleSmall,
                    ),
                  if (state.passedCoursesStatistics.isNotEmpty)
                    const SizedBox(height: 8),
                  ...state.passedCoursesStatistics
                      .map((e) => AddedCourseCard(courseStatistics: e)),
                  if (state.passedCoursesStatistics.isEmpty &&
                      state.addedCoursesStatistics.isEmpty)
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
