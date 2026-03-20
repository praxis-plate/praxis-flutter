import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key, required this.userProfile});

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return switch (state) {
              MainCoursesLoadSuccessState() => ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
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
              MainCoursesLoadErrorState() => ErrorScreen(
                message: state.failure.code.localizedMessage(context),
                onRetry: () => context.read<MainBloc>().add(
                  MainLoadCoursesEvent(userId: userProfile.id),
                ),
              ),
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
