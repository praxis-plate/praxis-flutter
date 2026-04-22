import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:praxis/features/main/bloc/main/main_bloc.dart';
import 'package:praxis/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:praxis/features/main/widgets/courses_section.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.userProfile});

  final UserProfileModel userProfile;

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
            child: _BalanceChipWrapper(),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [CoursesSection(userProfile: userProfile)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceChipWrapper extends StatelessWidget {
  const _BalanceChipWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
      builder: (context, state) {
        GetIt.I<Talker>().warning(state);
        if (state is! UserStatisticsLoadSuccessState) {
          return const SizedBox.shrink();
        }

        return _BalanceChip(amount: state.userStatistics.balance.amount);
      },
    );
  }
}

class _BalanceChip extends StatelessWidget {
  const _BalanceChip({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: CoinAmount(
        amount: amount,
        iconSize: 14,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
