import 'package:codium/core/bloc/user_profile/user_profile_bloc.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/features/profile/bloc/bloc/profile_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, userProfileState) {
        if (userProfileState is! UserProfileLoadedState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userId = userProfileState.profile.id;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  GetIt.I<UserStatisticsBloc>()
                    ..add(UserStatisticsLoadEvent(userId: userId.toString())),
            ),
            BlocProvider(
              create: (context) =>
                  GetIt.I<MainBloc>()
                    ..add(MainLoadCoursesEvent(userId: userId)),
            ),
            BlocProvider(
              create: (context) =>
                  GetIt.I<ProfileBloc>()..add(ProfileLoadEvent()),
            ),
          ],
          child: _MainScreenContent(userId: userId),
        );
      },
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  final int userId;

  const _MainScreenContent({required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).mainTitle, style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'AI Service Test',
            onPressed: () => context.push('/debug/ai-service-test'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final amount = state is ProfileLoadSuccessState
                      ? state.coinBalance
                      : 0;

                  GetIt.I<Talker>().warning('Coin balance: $amount');

                  return CoinAmount(
                    amount: amount,
                    iconSize: 20,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: _MainScreenBody(userId: userId),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  final int userId;

  const _MainScreenBody({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: BlocListener<CoursePurchasingBloc, CoursePurchasingState>(
        listener: (context, state) {
          if (state is CoursePurchasingLoadSuccessState) {
            context.read<MainBloc>().add(MainLoadCoursesEvent(userId: userId));
            context.read<ProfileBloc>().add(ProfileLoadEvent());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).coursePurchaseSuccess),
                backgroundColor: Theme.of(context).colorScheme.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CoursePurchasingLoadErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is CoursePurchasingInsufficientBalanceState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Недостаточно монет. Нужно: ${state.required}, '
                  'Доступно: ${state.available}',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: const _CoursesSection(),
      ),
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
        Text(S.of(context).courses, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        CommonSearchBar(
          hintText: S.of(context).searchCourse,
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
              MainCoursesLoadSuccessState() => ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: state.filteredCourses
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CourseCard(
                          course: e,
                          isPurchased: state.enrolledCourseIds.contains(e.id),
                          onPressed: () => context.push('/course/${e.id}'),
                        ),
                      ),
                    )
                    .toList(),
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
