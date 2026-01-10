import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/main.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key, required this.userProfile});

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.courses, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        CommonSearchBar(
          hintText: s.searchCourse,
          onChanged: (value) {
            context.read<MainBloc>().add(SearchCoursesEvent(value));
          },
          onClear: () {
            context.read<MainBloc>().add(const SearchCoursesEvent(''));
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return switch (state) {
              MainCoursesLoadSuccessState() => ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.filteredCourses.length,
                itemBuilder: (context, index) {
                  final e = state.filteredCourses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(
                      userProfile: userProfile,
                      course: e,
                      isPurchased: state.enrolledCourseIds.contains(e.id),
                      onPressed: () => context.push('/course/${e.id}'),
                    ),
                  );
                },
              ),
              MainCoursesLoadErrorState() => Text(state.message),
              MainCoursesLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            };
          },
        ),
      ],
    );
  }
}
