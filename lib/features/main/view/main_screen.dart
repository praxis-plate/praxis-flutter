import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/features/main/widgets/courses_section.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.userProfile});

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).mainTitle, style: theme.textTheme.titleLarge),
        actions: [
          BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
            builder: (context, state) {
              GetIt.I<Talker>().warning(state);
              if (state is! UserStatisticsLoadSuccessState) {
                return const SizedBox();
              }
              return Wrapper(
                child: Center(
                  child: CoinAmount(
                    amount: state.userStatistics.balance.amount,
                    iconSize: 20,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Wrapper(
        child: BlocListener<CoursePurchasingBloc, CoursePurchasingState>(
          listener: (context, state) {
            if (state is CoursePurchasingLoadSuccessState) {
              context.read<MainBloc>().add(
                MainLoadCoursesEvent(userId: userProfile.id),
              );
            }
          },
          child: CoursesSection(userProfile: userProfile),
        ),
      ),
    );
  }
}
