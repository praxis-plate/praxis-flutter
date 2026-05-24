import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:praxis/features/main/bloc/main/main_bloc.dart';
import 'package:praxis/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:praxis/features/main/widgets/courses_section.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.userProfile});

  final UserProfileModel userProfile;

  Future<void> _refresh(BuildContext context) async {
    context.read<MainBloc>().add(MainLoadCoursesEvent(userId: userProfile.id));
    context.read<UserStatisticsBloc>().add(
      UserStatisticsLoadEvent(userId: userProfile.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.mainTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        titleSpacing: 16,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _MainBalancePill(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: CommonSearchBar(
              hintText: s.searchCourse,
              onChanged: (value) {
                context.read<MainBloc>().add(SearchCoursesEvent(value));
              },
              onClear: () {
                context.read<MainBloc>().add(const SearchCoursesEvent(''));
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Wrapper(
          child: BlocListener<CoursePurchasingBloc, CoursePurchasingState>(
            listener: (context, state) {
              if (state is CoursePurchasingLoadSuccessState) {
                context.read<MainBloc>().add(
                  MainLoadCoursesEvent(userId: userProfile.id),
                );
              }
            },
            child: RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [CoursesSection(userProfile: userProfile)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainBalancePill extends StatelessWidget {
  const _MainBalancePill();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
      builder: (context, state) {
        if (state is! UserStatisticsLoadSuccessState) {
          return const SizedBox.shrink();
        }

        return CoinBalancePill(amount: state.userStatistics.balance.amount);
      },
    );
  }
}
