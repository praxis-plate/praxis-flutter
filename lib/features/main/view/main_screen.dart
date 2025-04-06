import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/widgets/course_card.dart';
import 'package:codium/core/widgets/course_carousel.dart';
import 'package:codium/core/widgets/course_search_bar.dart';
import 'package:codium/core/widgets/user_points_card.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/main_carousel/main_carousel_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<MainBloc>()..add(MainLoadCoursesEvent()),
        ),
        BlocProvider(
          create: (context) => GetIt.I<UserStatisticsBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              GetIt.I<MainCarouselBloc>()..add(MainCarouselLoadEvent()),
        ),
      ],
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticatedState) {
          context.read<UserStatisticsBloc>().add(
            UserStatisticsLoadEvent(userId: state.user.id),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).mainTitle,
            style: theme.textTheme.titleLarge,
          ),
        ),
        body: const _MainScreenBody(),
      ),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  const _MainScreenBody();

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: ListView(
        children: const [
          _UserStatisticsSection(),
          SizedBox(height: 8),
          _RecommendationsSection(),
          SizedBox(height: 8),
          _CoursesSection(),
        ],
      ),
    );
  }
}

class _UserStatisticsSection extends StatelessWidget {
  const _UserStatisticsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
      builder: (context, state) {
        return switch (state) {
          UserStatisticsLoadSuccessState() =>
            UserPointsCard(userStatistics: state.userStatistics),
          UserStatisticsLoadErrorState() => ErrorWidget(state.message),
          _ => const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).recommend,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        BlocBuilder<MainCarouselBloc, MainCarouselState>(
          builder: (context, state) {
            return switch (state) {
              MainCarouselLoadSuccessState() => CourseCarousel(
                  courseCards:
                      state.courses.map((e) => CourseCard(course: e)).toList(),
                ),
              MainCarouselLoadErrorState() => Text(state.message),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ],
    );
  }
}

class _CoursesSection extends StatelessWidget {
  const _CoursesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).courses,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        const CourseSearchBar(),
        const SizedBox(height: 16),
        BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return switch (state) {
              MainCoursesLoadSuccessState() => ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children:
                      state.courses.map((e) => CourseCard(course: e)).toList(),
                ),
              MainCoursesLoadErrorState() => Text(state.message),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ],
    );
  }
}
