import 'package:codium/core/widgets/common_search_bar.dart';
import 'package:codium/core/widgets/course_card.dart';
import 'package:codium/core/widgets/dumb/section.dart';
import 'package:codium/core/widgets/smart/user_balance_card.dart';
import 'package:codium/core/widgets/user_provider.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetIt.I<UserStatisticsBloc>()
                ..add(UserStatisticsLoadEvent(userId: user.id)),
        ),
        BlocProvider(
          create: (context) => GetIt.I<MainBloc>()..add(MainLoadCoursesEvent()),
        ),
      ],
      child: _MainScreenContent(user: user),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  final User user;

  const _MainScreenContent({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).mainTitle, style: theme.textTheme.titleLarge),
      ),
      body: _MainScreenBody(user: user),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  final User user;

  const _MainScreenBody({required this.user});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Wrapper(
      child: ListView(
        children: [
          Section(title: s.balance, widget: const UserBalanceCard()),
          const SizedBox(height: 8),
          const _CoursesSection(),
        ],
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
